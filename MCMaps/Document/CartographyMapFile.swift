//
//  CartograhpyMapFile.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var cartography = UTType(exportedAs: "net.marquiskurt.mcmap")
}

extension CartographyMap {
    static let sampleFile = CartographyMap(
        seed: 123,
        mcVersion: "1.21.3",
        name: "My World",
        pins: [
            .init(position: .init(x: 0, y: 0), name: "Spawn")
        ])
}

struct CartographyMapFile: FileDocument, Sendable, Equatable {
    typealias ImageMap = [String: Data]

    struct Keys {
        static let metadata = "Info.json"
        static let images = "Images"
    }

    static var readableContentTypes: [UTType] { [.cartography] }

    var map: CartographyMap
    var images: ImageMap = [:]

    init(map: CartographyMap, images: ImageMap = [:]) {
        self.map = map
        self.images = images
    }

    init(decoding data: Data) throws {
        let decoder = JSONDecoder()
        self.map = try decoder.decode(CartographyMap.self, from: data)
        self.images = [:]
    }

    init(configuration: ReadConfiguration) throws {
        let fileWrappers = configuration.file.fileWrappers
        guard let metadata = fileWrappers?[Keys.metadata], let metadataContents = metadata.regularFileContents else {
            throw CocoaError(CocoaError.fileReadCorruptFile)
        }
        let decoder = JSONDecoder()
        self.map = try decoder.decode(CartographyMap.self, from: metadataContents)
        if let imagesDir = fileWrappers?[Keys.images], imagesDir.isDirectory, let wrappers = imagesDir.fileWrappers {
            self.images = wrappers.reduce(into: [:]) { (imageMap, kvPair) in
                let (key, wrapper) = kvPair
                guard let data = wrapper.regularFileContents else { return }
                imageMap[key] = data
            }
        }
    }

    func prepareForExport() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(map)
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encodedMetadata = try prepareForExport()
        let metadataWrapper = FileWrapper(regularFileWithContents: encodedMetadata)

        var imageWrappers = [String: FileWrapper]()
        for (key, data) in self.images {
            imageWrappers[key] = FileWrapper(regularFileWithContents: data)
        }

        let imagesDirectoryWrapper = FileWrapper(directoryWithFileWrappers: imageWrappers)

        return FileWrapper(directoryWithFileWrappers: [
            Keys.metadata: metadataWrapper,
            Keys.images: imagesDirectoryWrapper,
        ])
    }
}

extension CartographyMapFile: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(contentType: .cartography) { file in
            try file.prepareForExport()
        } importing: { data in
            try CartographyMapFile(decoding: data)
        }

    }
}
