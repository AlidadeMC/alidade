//
//  OrnamentedView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 24-02-2025.
//

import AlidadeUI
import SwiftUI

/// An ornament view designed to sit in top of another view.
///
/// This view is typically used with ``OrnamentedView`` to display ornaments on top of an existing view, pinned to a
/// specified edge or other `Alignment`:
///
/// ```swift
/// OrnamentedView(background: Color.red) {
///     Ornament(alignment: .leading) {
///         Text("Hi, I'm an ornament!")
///     }
/// }
/// ```
@available(macOS, introduced: 15.0, deprecated: 26.0)
@available(iOS, introduced: 18.0, deprecated: 26.0)
struct Ornament<Content: View>: View {
    /// The edges that the ornament should be aligned to.
    var alignment: Alignment

    /// The contents that will be displayed as an ornament.
    var content: () -> Content

    var body: some View {
        Group {
            content()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
}

/// A view that displays a background with a series of ornaments placed on top of the view.
///
/// Tapping the view will show or hide the ornaments on iOS and iPadOS. Ornaments can be placed anywhere along the
/// edges of the containing view, or anywhere `Alignment` accepts.
@available(macOS, introduced: 15.0, deprecated: 26.0)
@available(iOS, introduced: 18.0, deprecated: 26.0)
struct OrnamentedView<Ornaments: View, BackgroundContent: View>: View {
    @State private var displayOrnaments: Bool = true

    var content: BackgroundContent
    var ornaments: () -> Ornaments
    #if DEBUG
        var tappedGesture: ((Self) -> Void)?
    #endif

    init(content: BackgroundContent, @ViewBuilder ornaments: @escaping () -> Ornaments) {
        self.displayOrnaments = true
        self.content = content
        self.ornaments = ornaments
    }

    #if DEBUG
        init(
            content: BackgroundContent, @ViewBuilder ornaments: @escaping () -> Ornaments,
            tappedGesture: ((Self) -> Void)? = nil
        ) {
            self.displayOrnaments = true
            self.content = content
            self.ornaments = ornaments
        }
    #endif

    init(@ViewBuilder _ content: @escaping () -> BackgroundContent, @ViewBuilder ornaments: @escaping () -> Ornaments) {
        self.displayOrnaments = true
        self.content = content()
        self.ornaments = ornaments
    }

    var body: some View {
        ZStack {
            ornaments()
                .if(!displayOrnaments) { view in
                    view.hidden()
                }
        }
        .background(
            content
                .onTapGesture(perform: toggleOrnamentDisplay)
        )
        .animation(.spring(duration: 0.3), value: displayOrnaments)
    }

    private func toggleOrnamentDisplay() {
        #if os(iOS)
            withAnimation {
                displayOrnaments.toggle()
            }
            #if DEBUG
                tappedGesture?(self)
            #endif
        #endif
    }
}

#Preview {
    OrnamentedView(content: Color.clear) {
        Ornament(alignment: .center) {
            Text("Hi there!")
        }
    }

}

#if DEBUG
    extension OrnamentedView {
        var testHooks: TestHooks { TestHooks(target: self) }

        @MainActor
        struct TestHooks {
            private let target: OrnamentedView

            fileprivate init(target: OrnamentedView) {
                self.target = target
            }

            var displayOrnaments: Bool { target.displayOrnaments }
        }
    }
#endif
