//
//  CartograhpyMapFile.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    /// The uniform type identifier associated with `.mcmap` package files.
    static let cartography = UTType(exportedAs: "net.marquiskurt.mcmap")
}

extension CartographyMap {
    /// A sample file used for debugging, testing, and preview purposes.
    ///
    /// This might also be used to create a map quickly via a template.
    static let sampleFile = CartographyMap(
        seed: 123,
        mcVersion: "1.21.3",
        name: "My World",
        pins: [
            .init(position: .init(x: 0, y: 0), name: "Spawn")
        ])
}

/// A structure representing the Minecraft map file format (`.mcmap`).
///
/// This structure is used to open, edit, write, and save files through SwiftUI.
struct CartographyMapFile: Sendable, Equatable {
    /// A typealias representing the mapping of image names to data blobs in the file.
    typealias ImageMap = [String: Data]

    /// A structure containing keys used to read from (and write to) an `.mcmap` file.
    ///
    /// This structure is designed to allow stable access to common pathways in an `.mcmap` file, rather than
    /// hardcoding each key into relevant methods.
    ///
    /// - SeeAlso: For more information on these keys and the general format, refer to <doc:FileFormat>.
    struct Keys {
        /// The key that points to the primary metadata file.
        static let metadata = "Info.json"

        /// The key that points to the location where images are stored.
        static let images = "Images"

        @available(*, unavailable)
        init() {}
    }

    /// The underlying Minecraft world map driven from the metadata.
    ///
    /// > Note: When removing pins from the map, call ``removePin(at:)`` instead of directly removing the pin, as the
    /// > former ensures that any associated photos are removed.
    var map: CartographyMap

    /// A map of all the images available in this file, and the raw data bytes for the images.
    var images: ImageMap = [:]

    /// Creates a map file from a world map and an image map.
    /// - Parameter map: The map structure to represent as the metadata.
    /// - Parameter images: The map containing the images available in this file.
    init(map: CartographyMap, images: ImageMap = [:]) {
        self.map = map
        self.images = images
    }

    /// Creates a file by decoding a data object.
    ///
    /// > Note: This initializer does not provide an image map. An empty image map will be provided instead.
    /// - Parameter data: The data object to decode the map metadata from.
    init(decoding data: Data) throws {
        let decoder = JSONDecoder()
        self.map = try decoder.decode(CartographyMap.self, from: data)
        self.images = [:]
    }

    /// Prepares the map metadata for an export or save operation.
    func prepareMetadataForExport() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(map)
    }

    /// Removes a player-created pin at a given index, deleting associated images with it.
    /// - Parameter index: The index of the pin to remove from the library.
    mutating func removePin(at index: [CartographyMapPin].Index) {
        guard map.pins.indices.contains(index) else { return }
        let pin = map.pins[index]
        if let images = pin.images {
            for image in images {
                self.images[image] = nil
            }
        }
        map.pins.remove(at: index)
    }

    /// Removes a series of player-created pins at a given index, deleting associated images with it.
    ///
    /// This is generally recommended for built-in SwiftUI facilities or mass pin deletion operations.
    /// - Parameter offsets: The offsets to delete pins from.
    mutating func removePins(at offsets: IndexSet) {
        var imagesToDelete = [String]()
        for offset in offsets {
            let pin = map.pins[offset]
            guard let images = pin.images else { continue }
            imagesToDelete.append(contentsOf: images)
        }
        for image in imagesToDelete {
            self.images[image] = nil
        }
        map.pins.remove(atOffsets: offsets)
    }
}

// MARK: - FileDocument Conformances

extension CartographyMapFile: FileDocument {
    static var readableContentTypes: [UTType] { [.cartography] }

    /// Creates a file from a read configuration.
    ///
    /// - Note: This is only used via SwiftUI, and it cannot be tested or invoked manually.
    ///
    /// - Parameter configuration: The configuration to read the file from.
    init(configuration: ReadConfiguration) throws {
        try self.init(fileWrappers: configuration.file.fileWrappers)
    }

    /// Creates a file from a series of file wrappers.
    /// - Parameter fileWrappers: The file wrappers to read the file from.
    init(fileWrappers: [String: FileWrapper]?) throws {
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

    /// Creates a file wrapper from a write configuration.
    ///
    /// - Note:This is only used via SwiftUI, and it cannot be tested or invoked manually.
    ///
    /// - Parameter configuration: The configuration to write the file to.
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return try wrapper()
    }

    /// Creates a file wrapper regardless of configuration.
    ///
    /// - Note: This is mostly used by SwiftUI, but it exists as a standalone method for testing purposes.
    func wrapper() throws -> FileWrapper {
        let encodedMetadata = try prepareMetadataForExport()
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

// MARK: - Transferable Conformances

// NOTE(alicerunsonfedora): This should also take the image map into account...

extension CartographyMapFile: Transferable {
    /// A representation of the data for exporting purposes.
    ///
    /// - Note: Images and the image map are _not_ considered in this representation.
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(contentType: .cartography) { file in
            try file.prepareMetadataForExport()
        } importing: { data in
            try CartographyMapFile(decoding: data)
        }

    }
}
