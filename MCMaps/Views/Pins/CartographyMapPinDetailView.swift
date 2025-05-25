//
//  CartographyMapPinDetailView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 18-02-2025.
//

import AlidadeUI
import PhotosUI
import SwiftUI
import TipKit

/// A detail view used to display the contents of a player-created pin.
///
/// This detail view also acts as a form to edit various aspects of a pin, such as its color or associated images.
/// The presentation of this view should be driven by the properties in ``CartographyRoute/pin(_:pin:)``.
struct CartographyMapPinDetailView: View {
    private enum Constants {
        #if os(macOS)
            static let placeholderVerticalOffset = 8.0
            static let photoRowInsets = EdgeInsets(all: 0)
        #else
            static let placeholderVerticalOffset = 16.0
            static let photoRowInsets = EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        #endif
    }

    private enum LocalTips {
        static let photosOnboarding = PinPhotoOnboardingTip()
    }

    @State private var photoItem: PhotosPickerItem?
    @State private var photoToUpdate: Image?

    /// The view model driving the pin detail view.
    ///
    /// Changes to the pin should automatically propagate upstream to the file hosted in this view model.
    var viewModel: CartographyPinViewModel

    var body: some View {
        List {
            VStack(alignment: .leading) {
                TextField("Name", text: viewModel.pin.name)
                    .allowsTightening(true)
                    .font(.title)
                    .bold()
                    .textFieldStyle(.plain)
                HStack {
                    Label(viewModel.pinLocationLabel, systemImage: "tree")
                        .font(.subheadline)
                        .monospaced()
                        .foregroundStyle(.secondary)
                        .help("Location in Overworld: \(viewModel.pinLocationLabel)")
                        .accessibilityLabel("Location in Overworld")
                        .accessibilityValue(viewModel.pinLocationLabel)
                    Label(viewModel.netherTranslatedCoordinate, systemImage: "flame")
                        .font(.subheadline)
                        .monospaced()
                        .foregroundStyle(.secondary)
                        .help("Location in Nether: \(viewModel.netherTranslatedCoordinate)")
                        .accessibilityLabel("Location in Nether")
                        .accessibilityValue(viewModel.netherTranslatedCoordinate)
                }
                .padding(.vertical, 2)
            }

            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            Group {
                if !viewModel.images().isEmpty {
                    Section("Photos") {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.images(), id: \.self) { imageData in
                                    Image(data: imageData)
                                        .resizable()
                                        .scaledToFit()
                                        .clipped()
                                        .clipShape(.rect(cornerRadius: 10))
                                }
                                #if !os(macOS)
                                    photoPicker
                                        .labelStyle(.iconOnly)
                                        .buttonStyle(.bordered)
                                        .controlSize(.extraLarge)
                                        .buttonBorderShape(.circle)
                                        .frame(maxWidth: .infinity)
                                #endif
                            }
                            .frame(height: 150)
                        }
                        #if os(macOS)
                            photoPicker
                                .padding(.top)
                        #endif
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(Constants.photoRowInsets)
                } else {
                    TipView(LocalTips.photosOnboarding)
                    photoPicker
                        .buttonStyle(.bordered)
                        #if !os(macOS)
                            .controlSize(.extraLarge)
                            .buttonBorderShape(.capsule)
                        #endif
                        .frame(maxWidth: .infinity)
                }
            }
            .listRowSeparator(.hidden)

            Section("Color") {
                HStack {
                    Spacer()
                    CartographyMapPinColorPicker(color: viewModel.pin.color)
                    Spacer()
                }
                .listRowInsets(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                .listRowSeparator(.hidden)
            }

            Section("About") {
                TextEditor(text: viewModel.pinAboutDescription)
                    .textEditorStyle(.plain)
                    .lineSpacing(1.2)
                    .font(.body)
                    .frame(minHeight: 200)
                    .padding(8)
                    .overlay(alignment: .topLeading) {
                        if viewModel.pinAboutDescription.wrappedValue.isEmpty {
                            Text("Write a description...")
                                .foregroundStyle(.secondary)
                                .opacity(0.5)
                                .offset(x: 16, y: Constants.placeholderVerticalOffset)
                        }
                    }
                    .background(Color.secondary.opacity(0.1))
                    .clipped()
                    .clipShape(.rect(cornerRadius: 10))
                    .scrollIndicators(.never)

                if viewModel.fileSupportsPinTags {
                    ChipTextField("Tags", chips: viewModel.pinTags, prompt: "Write a tag...")
                        .chipTextFieldStyle(.borderless)
                        .chipPlacement(.trailing)
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.inset)
        .scrollContentBackground(.visible)
        .animation(.default, value: viewModel.pin.wrappedValue)
        .onChange(of: photoItem) { _, newValue in
            Task {
                guard let newValue else { return }
                if let data = try await newValue.loadTransferable(type: Data.self) {
                    viewModel.uploadImage(data) {
                        LocalTips.photosOnboarding.invalidate(reason: .actionPerformed)
                    }
                } else {
                    print("Error")
                }
            }
        }
    }

    private var photoPicker: some View {
        Group {
            #if os(macOS)
                HStack {
                    Text("Add Photos")
                        .foregroundStyle(.secondary)
                    PhotosPicker(selection: $photoItem, matching: .images) {
                        Text("From Photos")
                    }
                    Button {
                        Task {
                            await getPhotoFromPanel()
                        }
                    } label: {
                        Text("From Finder")
                    }
                }
            #else
                PhotosPicker(selection: $photoItem, matching: .images) {
                    Label("Add Photos", systemImage: "plus")
                }
            #endif
        }
    }

    #if os(macOS)
        @discardableResult
        private func getPhotoFromPanel() async -> NSOpenPanel {
            let panel = NSOpenPanel()
            panel.directoryURL = FileManager.default.homeDirectoryForCurrentUser.appending(path: "Pictures")
            panel.canChooseDirectories = false
            panel.allowedContentTypes = [.image]
            if let keyWindow = NSApplication.shared.keyWindow {
                panel.beginSheetModal(for: keyWindow) { response in
                    switch response {
                    case .OK:
                        guard let path = panel.url else { return }
                        do {
                            let data = try Data(contentsOf: path)
                            viewModel.uploadImage(data) {
                                LocalTips.photosOnboarding.invalidate(reason: .actionPerformed)
                            }
                        } catch {
                            print("Failed to get image...")
                        }
                    default:
                        break
                    }
                }
            }
            return panel
        }
    #endif
}

#Preview {
    @Previewable @State var file = CartographyMapFile(withManifest: .sampleFile)
    NavigationStack {
        CartographyMapPinDetailView(viewModel: CartographyPinViewModel(file: $file, index: 0))
    }
}

#if DEBUG
    extension CartographyMapPinDetailView {
        var testHooks: TestHooks { TestHooks(target: self) }

        @MainActor
        struct TestHooks {
            private let target: CartographyMapPinDetailView

            fileprivate init(target: CartographyMapPinDetailView) {
                self.target = target
            }

            var photoItem: PhotosPickerItem? {
                target.photoItem
            }

            var photoToUpdate: Image? {
                target.photoToUpdate
            }

            #if os(macOS)
                func openSavePanel() async -> NSOpenPanel {
                    return await target.getPhotoFromPanel()
                }
            #endif
        }
    }
#endif
