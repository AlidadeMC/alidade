//
//  MinecraftMapContentBuilder.swift
//  CubiomesKit
//
//  Created by Marquis Kurt on 03-04-2025.
//

import MapKit
import SwiftUI

/// A protocol that defines content used in a ``MinecraftMapContentBuilder``.
///
/// This underlying type allows conversion to ``MinecraftMapContent`` which can be handled by map views that support
/// it.
public protocol MinecraftMapBuilderContent {
    /// The built contents of this type.
    var content: MinecraftMapContent { get }
}

/// A content builder used to generate Minecraft-based map annotations for map views from closures you provide.
@resultBuilder
public struct MinecraftMapContentBuilder {
    public static func buildArray(_ components: [[MinecraftMapBuilderContent]]) -> [any MinecraftMapContent] {
        components.flatMap { $0.map(\.content) }
    }

    public static func buildBlock(_ components: MinecraftMapBuilderContent...) -> [any MinecraftMapContent] {
        components.map(\.content)
    }

    public static func buildBlock(_ components: [MinecraftMapBuilderContent]...) -> [any MinecraftMapContent] {
        components.flatMap { $0.map(\.content) }
    }

    public static func buildEither(first component: MinecraftMapBuilderContent) -> [any MinecraftMapContent] {
        [component.content]
    }

    public static func buildEither(second component: MinecraftMapBuilderContent) -> [any MinecraftMapContent] {
        [component.content]
    }
}
