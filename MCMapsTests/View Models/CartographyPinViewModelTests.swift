//
//  CartographyPinViewModelTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 18-02-2025.
//

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

    @Test func viewModelInit() async throws {
        let file = CartographyMapFile(map: .sampleFile)
        let fileBinding: Binding<CartographyMapFile> = .init(wrappedValue: file)
        let vm = CartographyPinViewModel(file: fileBinding, index: 0)

        #expect(vm.testHooks.file.wrappedValue == file)
        #expect(vm.testHooks.index == 0)
        #expect(vm.pin.wrappedValue == file.map.pins[0])
        #expect(vm.images().isEmpty)
        #expect(vm.pinLocationLabel == "(0, 0)")
    }

    @MainActor
    @Test func viewModelPinBinding() async throws {
        let fileBinding: Binding<CartographyMapFile> = .init(wrappedValue: CartographyMapFile(map: .sampleFile))
        let vm = CartographyPinViewModel(file: fileBinding, index: 0)

        let view = PinModifierView(pin: vm.pin)
        let sut = try view.inspect().implicitAnyView().text()
        try sut.callOnAppear()

        #expect(fileBinding.wrappedValue.map.pins[0].name == "Geschlossene Erinnerungen")
    }
}
