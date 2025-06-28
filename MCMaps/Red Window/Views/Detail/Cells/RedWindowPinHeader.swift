//
//  RedWindowPinHeaderSection.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-06-2025.
//

import MCMapFormat
import SwiftUI

struct RedWindowPinHeader: RedWindowDetailCell {
    private enum Constants {
        static let headerHeight = 300.0
    }
    @Binding var pin: MCMapManifestPin
    @Binding var isEditing: Bool

    var file: CartographyMapFile

    private var gradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.black.opacity(1),
                Color.black.opacity(0)
            ],
            startPoint: .bottom,
            endPoint: .top)
    }

    var body: some View {
        Group {
            if let coverImage {
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
        .backgroundExtensionEffectIfAvailable()
        .overlay(alignment: .bottomLeading) {
            HStack {
                VStack(alignment: .leading) {
                    Group {
                        if isEditing {
                            TextField("", text: $pin.name, prompt: Text("Name"))
                        } else {
                            Text(pin.name)
                                .fontDesign(.serif)
                        }
                    }
                    .foregroundStyle(.primary)
                    .font(.largeTitle)
                    .bold()
                    Text("(\(Int(pin.position.x)), \(Int(pin.position.y)))")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .fontDesign(.monospaced)
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
                    .opacity(0.85)
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
                #if RED_WINDOW
                ToolbarItem {
                    if isEditing, #available(iOS 19, *) {
                        Button(role: .confirm) { isEditing.toggle() }
                    } else {
                        Button("Edit", systemImage: "pencil") { isEditing.toggle() }
                    }
                }
                #endif
            }
        }
    }
#endif
