//
//  CartographyMapPinDetailView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 18-02-2025.
//

import PhotosUI
import SwiftUI

struct CartographyMapPinDetailView: View {
    enum Constants {
        #if os(macOS)
            static let placeholderVerticalOffset = 8.0
            static let photoRowInsets = EdgeInsets(all: 0)
        #else
            static let placeholderVerticalOffset = 16.0
            static let photoRowInsets = EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        #endif
    }

    @State private var photoItem: PhotosPickerItem?
    @State private var photoToUpdate: Image?

    var viewModel: CartographyPinViewModel

    var body: some View {
        List {
            VStack(alignment: .leading) {
                TextField("Name", text: viewModel.pin.name)
                    .allowsTightening(true)
                    .font(.title)
                    .bold()
                    .textFieldStyle(.plain)
                Text(viewModel.pinLocationLabel)
                    .font(.subheadline)
                    .monospaced()
                    .foregroundStyle(.secondary)
            }

            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            Group {
                if !viewModel.images().isEmpty {
                    Section("Photos") {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.images(), id: \.self) { imageData in
                                    Image(data: imageData)?
                                        .resizable()
                                        .scaledToFit()
                                        .clipped()
                                        .clipShape(.rect(cornerRadius: 10))
                                }
                                photoPicker {
                                    Label("Add More", systemImage: "plus")
                                }
                                .labelStyle(.iconOnly)
                                .buttonStyle(.bordered)
                                .controlSize(.extraLarge)
                                .buttonBorderShape(.circle)
                                .frame(maxWidth: .infinity)
                            }
                            .frame(height: 150)
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(Constants.photoRowInsets)
                } else {
                    photoPicker {
                        Label("Add Photos", systemImage: "plus")
                    }
                    .buttonStyle(.bordered)
                    #if !os(macOS)
                    .controlSize(.extraLarge)
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
                .listRowInsets(.init(top: 2, leading: 0, bottom: 2, trailing: 0))
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
                    viewModel.uploadImage(data)
                } else {
                    print("Error")
                }
            }
        }
    }

    private func photoPicker(button: @escaping () -> some View) -> some View {
        Group {
            #if os(macOS)
                Menu {
                    PhotosPicker("Import From Photos...", selection: $photoItem, matching: .images)
                    Button {
                        Task {
                            await getPhotoFromPanel()
                        }
                    } label: {
                        Text("Add Files...")
                    }
                } label: {
                    button()
                }
                .menuStyle(.button)
                .menuIndicator(.hidden)
            #else
                PhotosPicker(selection: $photoItem, matching: .images) {
                    Label("Add Photos", systemImage: "plus")
                }
            #endif
        }
    }

    #if os(macOS)
    private func getPhotoFromPanel() async {
        let panel = NSOpenPanel()
        panel.directoryURL = FileManager.default.homeDirectoryForCurrentUser.appending(path: "Pictures")
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [.image]
        panel.begin { response in
            switch response {
            case .OK:
                guard let path = panel.url else { return }
                do {
                    let data = try Data(contentsOf: path)
                    viewModel.uploadImage(data)
                } catch {
                    print("Failed to get image...")
                }
            default:
                break
            }
        }
    }
    #endif
}

#Preview {
    @Previewable @State var file = CartographyMapFile(map: .sampleFile)
    NavigationStack {
        CartographyMapPinDetailView(viewModel: .init(file: $file, index: 0))
    }
}
