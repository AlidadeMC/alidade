//
//  CartographyPinViewModelTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 18-02-2025.
//

import MCMap
import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

struct CartographyPinViewModelTests {
    private struct PinModifierView: View {
        @Binding var pin: CartographyMapPin

        var body: some View {
            Text(pin.name)
                .onAppear {
                    pin.name = "Geschlossene Erinnerungen"
                }
        }
    }

    @Test(.tags(.viewModel))
    func viewModelInit() async throws {
        let file = CartographyMapFile(withManifest: .sampleFile)
        let fileBinding: Binding<CartographyMapFile> = Binding(wrappedValue: file)
        let vm = CartographyPinViewModel(file: fileBinding, index: 0)

        #expect(vm.testHooks.file.wrappedValue == file)
        #expect(vm.testHooks.index == 0)
        #expect(vm.pin.wrappedValue == file.pins[0])
        #expect(vm.images().isEmpty)
        #expect(vm.pinLocationLabel == "(0, 0)")
    }

    @MainActor
    @Test(.tags(.viewModel))
    func viewModelPinBinding() async throws {
        let fileBinding = Binding<CartographyMapFile>(wrappedValue: CartographyMapFile(withManifest: .sampleFile))
        let vm = CartographyPinViewModel(file: fileBinding, index: 0)

        let view = PinModifierView(pin: vm.pin)
        let sut = try view.inspect().text()
        try sut.callOnAppear()

        #expect(fileBinding.wrappedValue.pins[0].name == "Geschlossene Erinnerungen")
    }

    @Test(.tags(.viewModel))
    func viewModelImageUpload() async throws {
        let fileBinding = Binding<CartographyMapFile>(wrappedValue: CartographyMapFile(withManifest: .sampleFile))
        let vm = CartographyPinViewModel(file: fileBinding, index: 0)

        guard let image = Bundle(for: Helper.self).path(forResource: "sampleimage", ofType: "png") else {
            Issue.record("Example image is missing!")
            return
        }
        let data = try Data(contentsOf: .init(filePath: image))
        vm.uploadImage(data)

        #expect(!fileBinding.wrappedValue.images.isEmpty)
        #expect(fileBinding.wrappedValue.pins[0].images?.count == 1)
    }

    @Test(.tags(.viewModel))
    func viewModelPinDescription() async throws {
        let fileBinding = Binding<CartographyMapFile>(wrappedValue: CartographyMapFile(withManifest: .sampleFile))
        let vm = CartographyPinViewModel(file: fileBinding, index: 0)

        #expect(vm.pinAboutDescription.wrappedValue == "")

        vm.pinAboutDescription.wrappedValue = "This is the spawn point."
        #expect(fileBinding.wrappedValue.pins[0].description == "This is the spawn point.")
    }

    @Test(.tags(.viewModel))
    func viewModelPinLabels() async throws {
        var file = CartographyMapFile(withManifest: .sampleFile)
        file.pins[0].position = CGPoint(x: 1847, y: 1847)
        let fileBinding: Binding<CartographyMapFile> = .init(wrappedValue: file)
        let vm = CartographyPinViewModel(file: fileBinding, index: 0)

        #expect(vm.pinLocationLabel == "(1847, 1847)")
        #expect(vm.netherTranslatedCoordinate == "(231, 231)")
    }
}
