//
//  RedWindowPinHeaderSection.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-06-2025.
//

import ImageProcessing
import MCMap
import SwiftUI

/// A header view that displays the pin's title and coordinates.
///
/// The header view extends to the edge of the view, using a background extension effect to leverage the designs in
/// Liquid Glass. If the pin contains images, the first image in the list will be used; otherwise, a gradient of the
/// pin's color will be used.
///
/// Entering edit mode on the header will allow players to edit the title of the pin, switching to the default system
/// font.
struct RedWindowPinHeader: RedWindowDetailCell {
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast

    private enum Constants {
        static let headerHeight = 300.0
    }

    /// The pin to display the header for and allow editing of the title.
    @Binding var pin: CartographyMapPin

    /// Whether the view is in editing mode.
    @Binding var isEditing: Bool

    /// The file that contains the pin and images being displayed.
    var file: CartographyMapFile

    private var gradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.black.opacity(1),
                Color.black.opacity(0),
            ],
            startPoint: .bottom,
            endPoint: .top)
    }

    var body: some View {
        Group {
            if let coverImage, !isEditing, colorSchemeContrast == .standard {
                ZStack {
                    Color.black
                    Rectangle()
                        .fill(.clear)
                        .background(
                            Image(data: coverImage)
                                .resizable()
                                .scaledToFill()
                        )

                    ZStack {
                        Rectangle()
                            .fill(.thinMaterial)
                            .mask {
                                VStack(spacing: 0) {
                                    Spacer()
                                    VStack(spacing: 0) {
                                        gradient
                                        Rectangle()
                                    }
                                    .frame(height: Constants.headerHeight - (Constants.headerHeight / 2))
                                }
                            }
                    }
                }
            } else {
                defaultCover
            }
        }

        .frame(height: Constants.headerHeight)
        .backgroundExtensionEffect()
        .animation(.interactiveSpring, value: colorSchemeContrast)
        .overlay(alignment: .bottomLeading) {
            HStack {
                VStack(alignment: .leading) {
                    Group {
                        if isEditing {
                            TextField("", text: $pin.name, prompt: Text("Name"))
                                .textFieldStyle(.roundedBorder)
                        } else {
                            Text(pin.name)
                                .fontDesign(.serif)
                        }
                    }
                    .foregroundStyle(.primary)
                    .font(.largeTitle)
                    .bold()
                    PinCoordinateStack(pin: pin)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding()
        }
    }

    private var coverImage: Data? {
        guard let imageName = pin.images?.first else {
            return nil
        }
        return file.images[imageName]
    }

    private var defaultCover: some View {
        Rectangle()
            .fill(
                Color(pin.color?.swiftUIColor ?? .accent)
                    .opacity(0.75)
                    .gradient
            )
    }
}

#if os(iOS)
    #Preview {
        @Previewable @State var file = CartographyMapFile.preview
        @Previewable @State var pin = CartographyMapFile.previewPin
        @Previewable @State var isEditing = false
        NavigationStack {
            ScrollView {
                RedWindowPinHeader(pin: $pin, isEditing: $isEditing, file: file)
            }
            .ignoresSafeArea(.container)
            .toolbar {
                ToolbarItem {
                    if isEditing, #available(iOS 19, *) {
                        Button(role: .confirm) { isEditing.toggle() }
                    } else {
                        Button("Edit", systemImage: "pencil") { isEditing.toggle() }
                    }
                }
            }
        }
    }
#endif
