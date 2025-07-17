//
//  CartographyOrnamentMap.swift
//  MCMaps
//
//  Created by Marquis Kurt on 23-02-2025.
//

import AsyncAlgorithms
import Combine
import CubiomesKit
import MCMapFormat
import SwiftUI
import TipKit

/// A map view with various ornaments placed on top.
///
/// The ornament map displays the regular map while having various ornaments on top, such as the location badge,
/// direction navigator wheel, and dimension picker. On iOS and iPadOS, tapping the map will show or hide these
/// ornaments.
@available(macOS, introduced: 15.0, deprecated: 26.0)
@available(iOS, introduced: 18.0, deprecated: 26.0)
struct CartographyOrnamentMap: View {
    private typealias IntegrationServiceType = CartographyIntegrationService.ServiceType

    private enum LocalTips {
        static let dimensionPicker = WorldDimensionPickerTip()
    }

    private enum Constants {
        #if os(macOS)
            static let locationBadgePlacement = Alignment.bottomLeading
        #else
            static let locationBadgePlacement = Alignment.topTrailing
        #endif

        static let navigatorWheelPlacement = Alignment.bottomTrailing
    }
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @AppStorage(UserDefaults.Keys.mapNaturalColors.rawValue) private var naturalColors = true

    /// The view model the map will read from/write to.
    @Binding var viewModel: CartographyMapViewModel

    /// The file that the map will read from/write to.
    @Binding var file: CartographyMapFile

    @State private var centerCoordinate = CGPoint.zero
    private let centerCoordinateStream = AsyncChannel<CGPoint>()

    @State private var integrationData = [IntegrationServiceType: any CartographyIntegrationServiceData]()
    @State private var integrationFetchState = IntegrationFetchState.initial

    private let bmapTimer: Publishers.Autoconnect<Timer.TimerPublisher>

    private var integrationAnnotations: [any MinecraftMapBuilderContent] {
        var annotations = [any MinecraftMapBuilderContent]()
        for (key, value) in integrationData {
            switch key {
            case .bluemap:
                if let data = value as? BluemapResults {
                    annotations.append(contentsOf: data.annotations(from: file.integrations.bluemap))
                }
            }
        }
        return annotations
    }

    init(viewModel: Binding<CartographyMapViewModel>, file: Binding<CartographyMapFile>) {
        self._file = file
        self._viewModel = viewModel

        self.bmapTimer = Timer
            .publish(every: file.wrappedValue.integrations.bluemap.refreshRate, on: .main, in: .common)
            .autoconnect()
    }

    var body: some View {
        OrnamentedView {
            Group {
                if let world = try? MinecraftWorld(
                    version: file.manifest.worldSettings.version,
                    seed: file.manifest.worldSettings.seed
                ) {
                    MinecraftMap(
                        world: world,
                        centerCoordinate: $centerCoordinate,
                        dimension: viewModel.worldDimension
                    ) {
                        file.manifest.pins.map { pin in
                            Marker(
                                location: pin.position,
                                title: pin.name,
                                color: pin.color?.swiftUIColor ?? Color.accentColor
                            )
                        }
                        integrationAnnotations
                    }
                    .mapColorScheme(naturalColors == true ? .natural : .default)
                    .ornaments([.zoom, .compass])
                }
            }
            .edgesIgnoringSafeArea(.all)
            .background(Color.gray)
            .onChange(of: viewModel.worldRange.origin) { _, newValue in
                if centerCoordinate != CGPoint(minecraftPoint: newValue) {
                    centerCoordinate = CGPoint(minecraftPoint: newValue)
                }
            }
            .task(id: centerCoordinate, priority: .low) {
                await centerCoordinateStream.send(centerCoordinate)
            }
            .task {
                await updateIntegrationData()

                for await coordinate in centerCoordinateStream.debounce(for: .seconds(0.5)) {
                    let point = MinecraftPoint(cgPoint: coordinate)
                    if viewModel.worldRange.origin != point {
                        await MainActor.run {
                            viewModel.worldRange.origin = point
                        }
                    }
                }
            }
            .onReceive(bmapTimer) { _ in
                Task { await updateIntegrationData() }
            }
        } ornaments: {
            Ornament(alignment: Constants.locationBadgePlacement) {
                VStack(alignment: .trailing) {
                    #if os(iOS)
                    LocationBadge(location: centerCoordinate)
                        .environment(\.contentTransitionAddsDrawingGroup, true)
                        HStack {
                            Menu {
                                Toggle(isOn: $viewModel.renderNaturalColors) {
                                    Label("Natural Colors", systemImage: "paintpalette")
                                }
                                WorldDimensionPickerView(selection: $viewModel.worldDimension)
                                    .pickerStyle(.inline)
                            } label: {
                                Label("Dimension", systemImage: "map")
                            }
                            .popoverTip(LocalTips.dimensionPicker)
                            .ornamentButton()
                        }
                        .labelStyle(.iconOnly)
                        .padding(.trailing, 6)
                        .onChange(of: viewModel.worldDimension) { _, _ in
                            LocalTips.dimensionPicker.invalidate(reason: .actionPerformed)
                        }
                    #else
                    HStack(spacing: 0) {
                        IntegrationFetchStateView(state: integrationFetchState)
                            .padding(8)
                        LocationBadge(location: centerCoordinate)
                            .environment(\.contentTransitionAddsDrawingGroup, true)
                    }
                    #endif
                }
            }
            .padding(.trailing, 8)
        }
    }

    private func updateIntegrationData() async {
        let service = CartographyIntegrationService(serviceType: .bluemap, integrationSettings: file.integrations)
        do {
            withAnimation { integrationFetchState = .refreshing }
            let result: BluemapResults? = try await service.sync(dimension: viewModel.worldDimension)
            guard let result else {
                withAnimation { integrationFetchState = .error("Response returned empty.") }
                return
            }
            integrationData[.bluemap] = result
            withAnimation { integrationFetchState = .success(.now) }
        } catch CartographyIntegrationService.ServiceError.integrationDisabled {
            withAnimation {
                integrationFetchState = .cancelled
            }
        } catch {
            withAnimation {
                integrationFetchState = .error(error.localizedDescription)
            }
        }
    }
}

private struct OrnamentButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundStyle(.primary)
            .background(.thinMaterial)
            .clipped()
            .clipShape(.rect(cornerRadius: 8))
    }
}

extension View {
    fileprivate func ornamentButton() -> some View {
        self.modifier(OrnamentButtonModifier())
    }
}
