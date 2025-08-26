//
//  EaselView.swift
//  Easel
//
//  Created by Marquis Kurt on 25-08-2025.
//

import MapKit
import PencilKit
import SwiftUI

/// A view that provides a canvas layer for creating drawings using the Apple Pencil.
///
/// Easel views are used to allow players to draw over content views, such as maps. The tool picker can be shown or
/// hidden programmatically, and the drawing is bound for quick access and storage.
@available(iOS 18.0, *)
public struct EaselView<CanvasBackground: View> {
    /// The coordinator used to listen for delegate events.
    public class Coordinator: NSObject, EaselViewControllerDelegate {
        @Binding var drawing: PKDrawing

        init(drawing: Binding<PKDrawing>) {
            self._drawing = drawing
        }

        func easelViewController(_: EaselViewController, didChangeDrawing drawing: PKDrawing) {
            self.drawing = drawing
        }
    }

    @Binding var drawing: PKDrawing
    @Binding var isToolPickerPresented: Bool

    private var drawingPolicy: PKCanvasViewDrawingPolicy
    private var canvasBackground: (() -> CanvasBackground)?

    /// Create an easel view with a drawing.
    /// - Parameter drawing: The drawing that the easel view will manage.
    /// - Parameter canvasBackground: The background to use.
    public init(
        drawing: Binding<PKDrawing>,
        canvasBackground: (() -> CanvasBackground)? = nil
    ) {
        self._drawing = drawing
        self._isToolPickerPresented = .constant(true)
        self.drawingPolicy = .default
        self.canvasBackground = canvasBackground
    }

    private init(
        drawing: Binding<PKDrawing>,
        picker: Binding<Bool>,
        policy: PKCanvasViewDrawingPolicy,
        background: (() -> CanvasBackground)?
    ) {
        self._drawing = drawing
        self._isToolPickerPresented = picker
        self.drawingPolicy = policy
        self.canvasBackground = background
    }

    /// Sets the drawing policy on the easel view.
    /// - Parameter policy: The easel view's drawing policy.
    public func drawingPolicy(_ policy: PKCanvasViewDrawingPolicy) -> EaselView {
        EaselView(
            drawing: $drawing,
            picker: $isToolPickerPresented,
            policy: policy,
            background: canvasBackground
        )
    }

    /// Sets the visibility of the tool picker.
    ///
    /// When the tool picker is presented, the background view loses its interaction capabilities to prevent
    /// interference between the canvas and the background. User interaction with the background is restored when the
    /// tool picker is hidden.
    ///
    /// - Parameter isPresented: Whether the tool picker should be visible.
    public func toolPicker(isPresented: Binding<Bool>) -> EaselView {
        EaselView(
            drawing: $drawing,
            picker: isPresented,
            policy: drawingPolicy,
            background: canvasBackground
        )
    }
}

extension EaselView where CanvasBackground == EmptyView {
    /// Create an easel view with no background.
    /// - Parameter drawing: The drawing that the easel will manage.
    public init(drawing: Binding<PKDrawing>) {
        self._drawing = drawing
        self._isToolPickerPresented = .constant(true)
        self.drawingPolicy = .default
        self.canvasBackground = nil
    }
}

extension EaselView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = EaselViewController

    public func makeCoordinator() -> Coordinator {
        Coordinator(drawing: $drawing)
    }

    public func makeUIViewController(context: Context) -> EaselViewController {
        let viewController = EaselViewController()
        viewController.easelViewDelegate = context.coordinator
        if let canvasBackground {
            let hostingController = UIHostingController(rootView: canvasBackground())
            viewController.canvasBackgroundController = hostingController
        }
        if isToolPickerPresented {
            viewController.activateToolPicker()
        }
        return viewController
    }

    public func updateUIViewController(_ uiViewController: EaselViewController, context: Context) {
        if isToolPickerPresented {
            uiViewController.activateToolPicker()
        } else {
            uiViewController.deactivateToolPicker()
        }
    }
}

#if os(iOS)
#Preview {
    @Previewable @State var drawing = PKDrawing()
    @Previewable @State var toolPickerActive = true

    NavigationStack {
        EaselView(drawing: $drawing) {
            Map(interactionModes: .all)
        }
            .toolPicker(isPresented: $toolPickerActive)
            .drawingPolicy(.anyInput)
            .navigationTitle("Drawing Canvas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.editor)
        .ignoresSafeArea()
        .toolbar {
            Button("Tools", systemImage: "pencil.tip.crop.circle") {
                toolPickerActive.toggle()
            }
        }
    }
}
#endif
