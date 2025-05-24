//
//  ChipTextField.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 23-05-2025.
//

import SwiftUI

struct BorderedChipTextFieldStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.secondary.opacity(0.75), lineWidth: 0.5)
                    .padding(1)
            )
    }
}

/// A text entry field for a collection of chips.
///
/// The chip text field is typically used to allow users to write a collection of chips and optionally remove them by
/// typing information.
///
/// ```swift
/// import SwiftUI
/// import AlidadeUI
///
/// struct MyView: View {
///     @State private var chips = Set<String>()
///     var body: some View {
///         ChipTextField("Tags", chips: $chips)
///     }
/// }
/// ```
public struct ChipTextField: View {
    /// A typealias representing a collection of chips.
    public typealias ChipCollection = Set<String>

    /// An enumeration representing the styles of a chip text field.
    public enum Style {
        /// The plain chip text field style.
        case plain

        /// The rounded border chip text field style.
        case roundedBorder
    }

    /// The chips being edited by this view.
    @Binding public var chips: ChipCollection

    var title: LocalizedStringKey
    var submitWithSpaces: Bool = true
    var style = Style.plain

    @State private var text: String = ""
    @FocusState private var focused: Bool

    /// Initialize a chip text field.
    /// - Parameter titleKey: The localized string key representing the title for this field.
    /// - Parameter chips: The chips that will be edited within this field.
    /// - Parameter submitWithSpaces: Whether a space character should be considered as a submit action.
    public init(_ titleKey: LocalizedStringKey, chips: Binding<ChipCollection>, submitWithSpaces: Bool = true) {
        self._chips = chips
        self.title = titleKey
        self.submitWithSpaces = submitWithSpaces
    }

    init(_ titleKey: LocalizedStringKey, chips: Binding<ChipCollection>, submitWithSpaces: Bool, style: Style) {
        self._chips = chips
        self.title = titleKey
        self.submitWithSpaces = submitWithSpaces
        self.style = style
    }

    /// Configures the chip text field style for the current view.
    /// - Parameter style: The style to apply to this view.
    public func chipTextFieldStyle(_ style: Style) -> Self {
        ChipTextField(
            self.title,
            chips: self.$chips,
            submitWithSpaces: self.submitWithSpaces,
            style: style)
    }

    public var body: some View {
        ScrollView(.horizontal) {
            HStack {
                Text(title)
                    .layoutPriority(1)
                ForEach(Array(chips), id: \.self) { chip in
                    ChipView(text: chip) {
                        chips.remove(chip)
                    }
                }
                .layoutPriority(0.25)
                TextField("", text: $text)
                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .textFieldStyle(.plain)
                    .focused($focused)
            }
            .if(style == .roundedBorder) { view in
                view.padding(.all, 4)
            }
        }
        .if(style == .roundedBorder) { view in
            view.modifier(BorderedChipTextFieldStyleModifier())
        }
        .animation(.bouncy, value: chips)
        .onTapGesture {
            focused = true
        }
        .onSubmit {
            onSubmitText()
        }
        .onChange(of: text) { _, newValue in
            if !newValue.hasSuffix(" ") || !submitWithSpaces { return }
            let chipValue = String(newValue[newValue.startIndex..<newValue.index(before: newValue.endIndex)])
            withAnimation {
                chips.insert(chipValue)
                text = ""
            }
        }
    }

    #if DEBUG
        func updateText(to newValue: String) {
            self.text = newValue
        }
    #endif

    private func onSubmitText() {
        withAnimation {
            chips.insert(text)
            text = ""
        }
    }
}

// MARK: - Preview

private struct ChipPreviewViewModel {
    var chips: Set<String> = ["Cafe", "Augenwaldburg"]
    var emptyChips: Set<String> = []
    var chipsWithSpaces: Set<String> = ["Food"]
}

#Preview {
    @Previewable @State var viewModel = ChipPreviewViewModel()
    NavigationStack {
        Form {
            Section {
                ChipTextField(
                    "Tags", chips: $viewModel.emptyChips)
            } header: {
                Text("Standard")
            }
            Section {
                ChipTextField(
                    "Tags", chips: $viewModel.chips)
            } header: {
                Text("With Prefilled Content")
            }
            Section {
                ChipTextField(
                    "Tags",
                    chips: $viewModel.chipsWithSpaces,
                    submitWithSpaces: false)
            } header: {
                Text("Allow Spaces in Chips")
            }

            Section {
                ChipTextField(
                    "Tags", chips: $viewModel.emptyChips)
                .chipTextFieldStyle(.roundedBorder)
            } header: {
                Text("Standard, Bordered")
            }
            Section {
                ChipTextField(
                    "Tags", chips: $viewModel.chips)
                .chipTextFieldStyle(.roundedBorder)
            } header: {
                Text("With Prefilled Content, Bordered")
            }
        }
        .navigationTitle("Chip Text Field")
        #if os(macOS)
            .formStyle(.grouped)
        #endif
    }
}

// MARK: Test Hooks

#if DEBUG
extension ChipTextField {
    var testHooks: TestHooks { TestHooks(target: self) }

    @MainActor
    struct TestHooks {
        private let target: ChipTextField
        
        fileprivate init(target: ChipTextField) {
            self.target = target
        }

        var text: String {
            self.target.text
        }
    }
}
#endif
