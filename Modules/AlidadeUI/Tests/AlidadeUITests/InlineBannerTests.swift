//
//  InlineBannerTests.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 26-05-2025.
//

import DesignLibrary
import SwiftUI
import Testing
import ViewInspector

@testable import AlidadeUI

@MainActor
struct InlineBannerTests {
    typealias Variant = InlineBanner.Variant
    typealias Theme = SemanticColors.Alert

    @Test(.tags(.inlineBanner))
    func viewLayout() throws {
        let banner = InlineBanner("Truth Recovered", message: "This is as close to the truth as we will get.")

        #expect(banner.title == "Truth Recovered")
        #expect(banner.message == "This is as close to the truth as we will get.")
        #expect(banner.variant == .information)

        let sut = try banner.inspect()
        let label = try sut.label()
        let labelContents = try label.title()

        #expect(try labelContents.text(0).string() == "Truth Recovered")
        #expect(try labelContents.text(1).string() == "This is as close to the truth as we will get.")

        let labelIcon = try label.icon().image()

        #expect(try labelIcon.actualImage() == Image(systemName: "info.circle"))
    }

    @Test(
        .tags(.inlineBanner),
        arguments: [
            (Variant.information, "info.circle"),
            (Variant.success, "checkmark.circle"),
            (Variant.warning, "exclamationmark.triangle"),
            (Variant.error, "exclamationmark.circle"),
        ])
    func viewSystemImageFromVariant(variant: Variant, systemImage: String) throws {
        let banner = InlineBanner("Truth Recovered", message: "This is as close to the truth as we will get.")
            .inlineBannerVariant(variant)

        #expect(banner.systemImage == systemImage)
    }

    @Test(
        .tags(.inlineBanner),
        arguments: [
            (Variant.information, Theme.infoBackground, Theme.infoForeground),
            (Variant.success, Theme.successBackground, Theme.successForeground),
            (Variant.warning, Theme.warningBackground, Theme.warningForeground),
            (Variant.error, Theme.errorBackground, Theme.errorForeground),
        ])
    func viewColorFromVariant(variant: Variant, background: ColorSchemeSet, foreground: ColorSchemeSet) throws {
        let banner = InlineBanner("Truth Recovered", message: "This is as close to the truth as we will get.")
            .inlineBannerVariant(variant)

        #expect(banner.backgroundColor == background.resolve(with: .light))
        #expect(banner.foregroundColor == foreground.resolve(with: .light))
    }
}
