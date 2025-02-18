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

struct CartographyMapFile: FileDocument, Sendable {
    static var readableContentTypes: [UTType] { [.cartography] }

    var map: CartographyMap

    init(map: CartographyMap) {
        self.map = map
    }

    init(decoding data: Data) throws {
        let decoder = JSONDecoder()
        self.map = try decoder.decode(CartographyMap.self, from: data)
    }

    init(configuration: ReadConfiguration) throws {
        guard let metadata = configuration.file.fileWrappers?["Info.json"],
              let metadataContents = metadata.regularFileContents else {
            throw CocoaError(CocoaError.fileReadCorruptFile)
        }
        let decoder = JSONDecoder()
        self.map = try decoder.decode(CartographyMap.self, from: metadataContents)
    }

    func prepareForExport() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(map)
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encodedMetadata = try prepareForExport()
        let metadataWrapper = FileWrapper(regularFileWithContents: encodedMetadata)
        return FileWrapper(directoryWithFileWrappers: [
            "Info.json": metadataWrapper
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
