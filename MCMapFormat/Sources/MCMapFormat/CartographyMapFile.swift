//
//  CartograhpyMapFile.swift
//  MCMaps
//
//  Created by Marquis Kurt on 31-01-2025.
//

import SwiftUI
import UniformTypeIdentifiers
import VersionedCodable

extension UTType {
    /// The uniform type identifier associated with `.mcmap` package files.
    public static let mcmap = UTType(exportedAs: "net.marquiskurt.mcmap")
}

/// A structure representing the Minecraft map file format (`.mcmap`).
///
/// This structure is used to open, edit, write, and save files through SwiftUI.
public struct CartographyMapFile: Sendable, Equatable {
    /// A typealias representing the manifest for the current file.
    public typealias Manifest = MCMapManifest

    /// A typealias representing the mapping of image names to data blobs in the file.
    public typealias ImageMap = [String: Data]

    /// A structure containing information about the app's state.
    ///
    /// Generally, these items should be stored in the user's preferences via `UserDefaults`. However, some pieces of
    /// data may be reliant on the current file being open, and it shouldn't pollute the user defaults space. Most of
    /// these features are supported in v2 of the format and later.
    public struct AppState: Sendable, Equatable, Hashable {
        /// The tab view customization for the current document.
        ///
        /// This is only applicable to the Red Window design.
        public var tabCustomization = TabViewCustomization()

        public func hash(into hasher: inout Hasher) {
            let encoder = JSONEncoder()
            do {
                let encoded = try encoder.encode(tabCustomization)
                hasher.combine(encoded)
            } catch {
                print("Unable to encode the tab customization.")
            }
        }
    }

    /// A structure containing integrations with other services.
    public struct Integrations: Sendable, Equatable, Hashable {
        /// Integration with a Bluemap server.
        public var bluemap = MCMapBluemapIntegration(baseURL: "")
    }

    /// A structure that defines several keys used for paths to folders or files in the package.
    public struct Keys {
        /// The key that points to the primary manifest file.
        public static let metadata = "Info.json"

        /// The key that points to where images are stored on disk.
        public static let images = "Images"

        /// The key that points to where information about the app's current state is stored.
        public static let appState = "AppState"

        /// The key that points to the tab customizations file, located inside of ``appState``.
        public static let appStateTabs = "Tabs.json"

        /// The key that points to where information about integrations with other services are stored.
        public static let integrations = "Integrations"

        @available(*, unavailable)
        init() {}
    }

    enum Constants {
        /// The minimum manifest version to assign to a file if the ``MCMapManifest/manifestVersion`` is undefined.
        ///
        /// This should be used when exporting or saving data to automatically "repair" or correct files that lack a
        /// manifest version key.
        static let minimumManifestVersion = 1
    }

    /// The manifest file that describes the structure and behavior of the map file, such as player created pins,
    /// version, and seed.
    ///
    /// In previous versions of the codebase, this was called the `map`. This property should be versioned and
    /// documented in <doc:FileFormat>.
    ///
    /// > Note: When removing pins from the map, call ``removePin(at:)`` instead of directly removing the pin, as the
    /// > former ensures that any associated photos are removed.
    public var manifest: Manifest

    /// A map of all the images available in this file, and the raw data bytes for the images.
    public var images: ImageMap = [:]

    /// The app state as driven from the current file.
    ///
    /// This is generally used to house preferences for the app relative to the current file being open, such as which
    /// tabs will be displayed.
    public var appState = AppState()

    /// The features that the current file supports.
    public var supportedFeatures: CartographyMapFeatures {
        CartographyMapFeatures(representing: self)
    }

    /// The integrations provided with this file.
    public var integrations = Integrations()

    /// A set containing all the available tags in the manifest's pins.
    public var tags: Set<String> {
        guard supportedFeatures.contains(.pinTagging) else { return [] }
        var tags = Set<String>()
        for pin in manifest.pins {
            if let pinTags = pin.tags {
                tags.formUnion(pinTags)
            }
        }
        return tags
    }

    /// Creates a map file from a world map and an image map.
    /// - Parameter manifest: The map structure to represent as the metadata.
    /// - Parameter images: The map containing the images available in this file.
    public init(withManifest manifest: MCMapManifest, images: ImageMap = [:]) {
        self.manifest = manifest
        self.images = images
        self.appState = AppState()
    }

    /// Creates a file by decoding a data object.
    ///
    /// > Note: This initializer does not provide an image map. An empty image map will be provided instead.
    /// - Parameter data: The data object to decode the map metadata from.
    public init(decoding data: Data) throws {
        let decoder = JSONDecoder()
        self.manifest = try decoder.decode(versioned: MCMapManifest.self, from: data)
        self.images = [:]
        self.appState = AppState()
        self.integrations = Integrations()
    }

    /// Prepares the map metadata for an export or save operation.
    func prepareMetadataForExport() throws -> Data {
        var transformedMap = manifest
        if transformedMap.manifestVersion == nil {
            transformedMap.manifestVersion = Constants.minimumManifestVersion
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(versioned: transformedMap)
    }

    /// Removes a player-created pin at a given index, deleting associated images with it.
    /// - Parameter index: The index of the pin to remove from the library.
    public mutating func removePin(at index: [MCMapManifestPin].Index) {
        guard manifest.pins.indices.contains(index) else { return }
        let pin = manifest.pins[index]
        if let images = pin.images {
            for image in images {
                self.images[image] = nil
            }
        }
        manifest.pins.remove(at: index)
    }

    /// Removes a series of player-created pins at a given index, deleting associated images with it.
    ///
    /// This is generally recommended for built-in SwiftUI facilities or mass pin deletion operations.
    /// - Parameter offsets: The offsets to delete pins from.
    public mutating func removePins(at offsets: IndexSet) {
        var imagesToDelete = [String]()
        for offset in offsets {
            let pin = manifest.pins[offset]
            guard let images = pin.images else { continue }
            imagesToDelete.append(contentsOf: images)
        }
        for image in imagesToDelete {
            self.images[image] = nil
        }
        manifest.pins.remove(atOffsets: offsets)
    }
}

// MARK: - FileDocument Conformances

extension CartographyMapFile: FileDocument {
    public static var readableContentTypes: [UTType] { [.mcmap] }

    static func jsonEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }

    /// Creates a file from a read configuration.
    ///
    /// - Note: This is only used via SwiftUI, and it cannot be tested or invoked manually.
    ///
    /// - Parameter configuration: The configuration to read the file from.
    public init(configuration: ReadConfiguration) throws {
        try self.init(fileWrappers: configuration.file.fileWrappers)
    }

    /// Creates a file from a series of file wrappers.
    /// - Parameter fileWrappers: The file wrappers to read the file from.
    init(fileWrappers: [String: FileWrapper]?) throws {
        guard let metadata = fileWrappers?[Keys.metadata], let metadataContents = metadata.regularFileContents else {
            throw CocoaError(CocoaError.fileReadCorruptFile)
        }
        let decoder = JSONDecoder()
        self.manifest = try decoder.decode(versioned: MCMapManifest.self, from: metadataContents)
        if let imagesDir = fileWrappers?[Keys.images], imagesDir.isDirectory, let wrappers = imagesDir.fileWrappers {
            self.images = wrappers.reduce(into: [:]) { (imageMap, kvPair) in
                let (key, wrapper) = kvPair
                guard let data = wrapper.regularFileContents else { return }
                imageMap[key] = data
            }
        }

        self.appState = AppState()
        if let asDir = fileWrappers?[Keys.appState], asDir.isDirectory, let wrappers = asDir.fileWrappers {
            if let tabCustomizationFile = wrappers[Keys.appStateTabs]?.regularFileContents {
                let decoder = JSONDecoder()
                appState.tabCustomization = try decoder.decode(TabViewCustomization.self, from: tabCustomizationFile)
            }
        }

        self.integrations = Integrations()
        if let intDir = fileWrappers?[Keys.integrations], intDir.isDirectory, let wrappers = intDir.fileWrappers {
            if let bluemap = wrappers[MCMapBluemapIntegration.integrationKey]?.regularFileContents {
                let decoder = JSONDecoder()
                integrations.bluemap = try decoder.decode(MCMapBluemapIntegration.self, from: bluemap)
            }
        }
    }

    /// Creates a file wrapper from a write configuration.
    ///
    /// - Note:This is only used via SwiftUI, and it cannot be tested or invoked manually.
    ///
    /// - Parameter configuration: The configuration to write the file to.
    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
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

        let fileWrapper = FileWrapper(directoryWithFileWrappers: [
            Keys.metadata: metadataWrapper,
            Keys.images: imagesDirectoryWrapper,
        ])

        var appStateWrapperFiles = [String: FileWrapper]()
        if supportedFeatures.contains(.tabCustomization) {
            let tabData = try Self.jsonEncoder().encode(appState.tabCustomization)
            appStateWrapperFiles[Keys.appStateTabs] = FileWrapper(regularFileWithContents: tabData)
        }

        var integrationsWrapperFiles = [String: FileWrapper]()
        if supportedFeatures.contains(.integrations) {
            let bluemap = try Self.jsonEncoder().encode(integrations.bluemap)
            integrationsWrapperFiles[MCMapBluemapIntegration.integrationKey] = FileWrapper(
                regularFileWithContents: bluemap)
        }

        if supportedFeatures != .minimumDefault {
            let appStateWrapper = FileWrapper(directoryWithFileWrappers: appStateWrapperFiles)
            appStateWrapper.preferredFilename = Keys.appState
            fileWrapper.addFileWrapper(appStateWrapper)

            let integrationsWrapper = FileWrapper(directoryWithFileWrappers: integrationsWrapperFiles)
            integrationsWrapper.preferredFilename = Keys.integrations
            fileWrapper.addFileWrapper(integrationsWrapper)
        }

        return fileWrapper
    }
}

// MARK: - Transferable Conformances

// NOTE(alicerunsonfedora): This should also take the image map into account...

extension CartographyMapFile: Transferable {
    /// A representation of the data for exporting purposes.
    ///
    /// - Note: Images and the image map are _not_ considered in this representation.
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(contentType: .mcmap) { file in
            try file.prepareMetadataForExport()
        } importing: { data in
            try CartographyMapFile(decoding: data)
        }

    }
}

// MARK: - Hashable Conformance

extension CartographyMapFile: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(manifest)
        for (name, image) in images {
            hasher.combine(name)
            hasher.combine(image)
        }
        hasher.combine(integrations)
        hasher.combine(appState)
    }
}
