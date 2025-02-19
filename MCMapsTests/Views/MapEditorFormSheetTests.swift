//
//  MapEditorFormSheetTests.swift
//  MCMaps
//
//  Created by Marquis Kurt on 13-02-2025.
//

import SwiftUI
import Testing
import ViewInspector

@testable import Alidade

@MainActor
struct MapEditorFormSheetTests {
    @Test func viewLayout() throws {
        let file: Binding<CartographyMapFile> = .init(wrappedValue: CartographyMapFile(map: .sampleFile))
        let view = MapEditorFormSheet(file: file)
        let sut = try view.inspect().implicitAnyView()

        let form = try sut.navigationStack().view(MapCreatorForm.self)
        #if os(iOS)
            #expect(try form.navigationBarBackButtonHidden() == true)
        #endif

        let toolbar = try form.toolbar()
        #expect(!toolbar.isAbsent)

        let doneButtonItem = try toolbar.item(0)
        let doneButton = try doneButtonItem.button()
        #expect(try doneButtonItem.placement() == .confirmationAction)
        #expect(try doneButton.labelView().text().string() == "Done")

        let cancelButtonItem = try toolbar.item(1)
        let cancelButton = try cancelButtonItem.button()
        #expect(try cancelButtonItem.placement() == .cancellationAction)
        #expect(try cancelButton.labelView().text().string() == "Cancel")
    }

    @Test func formSubmitCallback() throws {
        let file: Binding<CartographyMapFile> = .init(wrappedValue: CartographyMapFile(map: .sampleFile))
        let view = MapEditorFormSheet(file: file) {
            #expect(file.wrappedValue.map == .sampleFile)
        } onCancelChanges: {
            Issue.record("This callback shouldn't have been executed.")
        }
        let sut = try view.inspect().implicitAnyView()
        try sut.find(button: "Done").tap()
    }

    @Test func formCancelCallback() throws {
        let file: Binding<CartographyMapFile> = .init(wrappedValue: CartographyMapFile(map: .sampleFile))
        let view = MapEditorFormSheet(file: file) {
            Issue.record("This callback shouldn't have been executed.")
        } onCancelChanges: {
            #expect(file.wrappedValue.map == .sampleFile)
        }
        let sut = try view.inspect().implicitAnyView()
        try sut.find(button: "Cancel").tap()
    }
}
