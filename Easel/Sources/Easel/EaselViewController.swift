//
//  EaselViewController.swift
//  Easel
//
//  Created by Marquis Kurt on 25-08-2025.
//

import PencilKit

protocol EaselViewControllerDelegate: AnyObject {
    func easelViewController(_ viewController: EaselViewController, didChangeDrawing drawing: PKDrawing)
}

#if canImport(UIKit)
import UIKit

public class EaselViewController: UIViewController {
    private lazy var drawingCanvas: PKCanvasView = {
        let canvasView = PKCanvasView(frame: .zero)
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.drawingPolicy = drawingPolicy
        canvasView.isOpaque = false
        canvasView.backgroundColor = .clear
        return canvasView
    }()

    var drawingPolicy: PKCanvasViewDrawingPolicy = .default {
        didSet { drawingCanvas.drawingPolicy = self.drawingPolicy }
    }

    var canvasBackgroundController: UIViewController? {
        didSet { didSetCanvasBackgroundController() }
    }

    weak var easelViewDelegate: EaselViewControllerDelegate?

    private var toolPicker = PKToolPicker()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented. Are you using storyboards?")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(drawingCanvas)
        NSLayoutConstraint.activate([
            drawingCanvas.topAnchor.constraint(equalTo: view.topAnchor),
            drawingCanvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            drawingCanvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            drawingCanvas.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        toolPicker.addObserver(drawingCanvas)
        toolPicker.setVisible(true, forFirstResponder: drawingCanvas)
    }

    func activateToolPicker() {
        if drawingCanvas.isFirstResponder { return }
        drawingCanvas.becomeFirstResponder()
        canvasBackgroundController?.view.isUserInteractionEnabled = false
    }

    func deactivateToolPicker() {
        if !drawingCanvas.isFirstResponder { return }
        drawingCanvas.resignFirstResponder()
        drawingCanvas.isUserInteractionEnabled = false
        if let canvasBackgroundController {
            canvasBackgroundController.view.isUserInteractionEnabled = true
            canvasBackgroundController.becomeFirstResponder()
        }
    }

    private func didSetCanvasBackgroundController() {
        if let canvasBackgroundController {
            canvasBackgroundController.view.translatesAutoresizingMaskIntoConstraints = false
            addChild(canvasBackgroundController)
            drawingCanvas.isOpaque = false
            drawingCanvas.backgroundColor = .clear
            view.insertSubview(canvasBackgroundController.view, at: 0)
            
            NSLayoutConstraint.activate([
                canvasBackgroundController.view.topAnchor.constraint(equalTo: view.topAnchor),
                canvasBackgroundController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                canvasBackgroundController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                canvasBackgroundController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            canvasBackgroundController.didMove(toParent: self)
        }
    }
}

extension EaselViewController: PKCanvasViewDelegate {
    public func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        easelViewDelegate?.easelViewController(self, didChangeDrawing: canvasView.drawing)
    }
}
#endif
