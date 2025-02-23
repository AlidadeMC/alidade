//
//  Zoomable.swift
//  MCMaps
//
//  Created by Marquis Kurt on 23-02-2025.
//  Original: https://github.com/ryohey/Zoomable
//

import SwiftUI

/// A modifier used for handling zooming and panning interactions.
///
/// When a user interacts with a view containing this modifier, they can pinch to zoom and pan around with their
/// finger. On macOS, the pointer style is automatically updated depending on the zoom's state.
///
/// - Note: Currently, scrolling with two fingers isn't supported.
struct ZoomableModifier: ViewModifier {
    /// The minimum zoom scale factor.
    let minZoomScale: CGFloat

    /// The factor to scale by when the double-tap gesture is invoked.
    let doubleTapZoomScale: CGFloat

    @State private var lastTransform: CGAffineTransform = .identity
    @State private var transform: CGAffineTransform = .identity
    @State private var contentSize: CGSize = .zero
    #if os(macOS)
        @State private var pointerStyle: PointerStyle = .zoomIn
    #endif

    func body(content: Content) -> some View {
        content
            .background(alignment: .topLeading) {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            contentSize = proxy.size
                        }
                }
            }
            .animatableTransformEffect(transform)
            .gesture(dragGesture, including: transform == .identity ? .none : .all)
            .gesture(magnificationGesture)
            .gesture(doubleTapGesture)
            #if os(macOS)
                .pointerStyle(pointerStyle)
            #endif
    }

    private var magnificationGesture: some Gesture {
        MagnifyGesture(minimumScaleDelta: 0)
            .onChanged { value in
                let newTransform = CGAffineTransform.anchoredScale(
                    scale: value.magnification,
                    anchor: value.startAnchor.scaledBy(contentSize)
                )

                withAnimation(.interactiveSpring) {
                    transform = lastTransform.concatenating(newTransform)
                }
            }
            .onEnded { _ in
                onEndGesture()
            }
    }

    private var doubleTapGesture: some Gesture {
        SpatialTapGesture(count: 2)
            .onEnded { value in
                let newTransform: CGAffineTransform =
                    if transform.isIdentity {
                        .anchoredScale(scale: doubleTapZoomScale, anchor: value.location)
                    } else {
                        .identity
                    }

                withAnimation(.linear(duration: 0.15)) {
                    transform = newTransform
                    lastTransform = newTransform
                    #if os(macOS)
                    pointerStyle = newTransform.isIdentity ? .zoomIn : .zoomOut
                    #endif
                }
            }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                #if os(macOS)
                    pointerStyle = .grabActive
                #endif
                withAnimation(.interactiveSpring) {
                    transform = lastTransform.translatedBy(
                        x: value.translation.width / transform.scaleX,
                        y: value.translation.height / transform.scaleY
                    )
                }
            }
            .onEnded { _ in
                onEndGesture()
            }
    }

    private func onEndGesture() {
        let newTransform = limitTransform(transform)

        #if os(macOS)
            pointerStyle = .grabIdle
        #endif

        withAnimation(.snappy(duration: 0.1)) {
            transform = newTransform
            lastTransform = newTransform
        }
    }

    private func limitTransform(_ transform: CGAffineTransform) -> CGAffineTransform {
        let scaleX = transform.scaleX
        let scaleY = transform.scaleY

        if scaleX < minZoomScale || scaleY < minZoomScale {
            return .identity
        }

        let maxX = contentSize.width * (scaleX - 1)
        let maxY = contentSize.height * (scaleY - 1)

        if transform.tx > 0
            || transform.tx < -maxX
            || transform.ty > 0
            || transform.ty < -maxY
        {  // swiftlint:disable:this opening_brace
            // swiftlint:disable identifier_name
            let tx = min(max(transform.tx, -maxX), 0)
            let ty = min(max(transform.ty, -maxY), 0)
            // swiftlint:enable identifier_name
            var transform = transform
            transform.tx = tx
            transform.ty = ty
            return transform
        }

        return transform
    }
}

extension View {
    /// Allow zooming and panning this view in its parent container.
    ///
    /// When a user interacts with a view containing this modifier, they can pinch to zoom and pan around with their
    /// finger. On macOS, the pointer style is automatically updated depending on the zoom's state.
    ///
    /// - Note: Currently, scrolling with two fingers isn't supported.
    ///
    /// - Parameter minZoomScale: The minimum scale factor to allow zooming to.
    /// - Parameter doubleTapZoomScale: The scale to zoom to/from when the double tap gesture is invoked.
    @ViewBuilder
    public func zoomable(
        minZoomScale: CGFloat = 1,
        doubleTapZoomScale: CGFloat = 3
    ) -> some View {
        modifier(
            ZoomableModifier(
                minZoomScale: minZoomScale,
                doubleTapZoomScale: doubleTapZoomScale
            ))
    }

    /// Allow zooming and panning this view in its parent container.
    ///
    /// When a user interacts with a view containing this modifier, they can pinch to zoom and pan around with their
    /// finger. On macOS, the pointer style is automatically updated depending on the zoom's state.
    ///
    /// - Note: Currently, scrolling with two fingers isn't supported.
    ///
    /// - Parameter minZoomScale: The minimum scale factor to allow zooming to.
    /// - Parameter doubleTapZoomScale: The scale to zoom to/from when the double tap gesture is invoked.
    /// - Parameter outOfBoundsColor: The background color to apply when the view appears out of bounds during zooming.
    @ViewBuilder
    public func zoomable(
        minZoomScale: CGFloat = 1,
        doubleTapZoomScale: CGFloat = 3,
        outOfBoundsColor: Color = .clear
    ) -> some View {
        GeometryReader { _ in
            ZStack {
                outOfBoundsColor
                self.zoomable(
                    minZoomScale: minZoomScale,
                    doubleTapZoomScale: doubleTapZoomScale
                )
            }
        }
    }
}

extension View {
    @ViewBuilder
    fileprivate func animatableTransformEffect(_ transform: CGAffineTransform) -> some View {
        scaleEffect(
            x: transform.scaleX,
            y: transform.scaleY,
            anchor: .zero
        )
        .offset(x: transform.tx, y: transform.ty)
    }
}

extension UnitPoint {
    fileprivate func scaledBy(_ size: CGSize) -> CGPoint {
        .init(
            x: x * size.width,
            y: y * size.height
        )
    }
}

extension CGAffineTransform {
    fileprivate static func anchoredScale(scale: CGFloat, anchor: CGPoint) -> CGAffineTransform {
        CGAffineTransform(translationX: anchor.x, y: anchor.y)
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: -anchor.x, y: -anchor.y)
    }

    fileprivate var scaleX: CGFloat {
        sqrt(a * a + c * c)
    }

    fileprivate var scaleY: CGFloat {
        sqrt(b * b + d * d)
    }
}
