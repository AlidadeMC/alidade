//
//  ChipTextField.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 23-05-2025.
//

import SwiftUI

struct BorderedChipTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.all, 4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.secondary.opacity(0.75), lineWidth: 0.5)
                    .padding(1)
            )
    }
}

struct BorderlessChipTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.all, 4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.secondary.opacity(0.1))
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

        /// The borderless chip text field style.
        case borderless
    }

    /// An enumeration representing the valid placements for chips in the text field.
    public enum ChipPlacement {
        /// The leading placement of the text field.
        ///
        /// Chips will appear before the text entry field.
        case leading
        
        /// The trailing placement of the text field.
        ///
        /// Chips will appear after the text entry field.
        case trailing
    }
    
    /// The chips being edited by this view.
    @Binding public var chips: ChipCollection

    var title: LocalizedStringKey
    var prompt: LocalizedStringKey = ""
    var submitWithSpaces: Bool = true
    var style = Style.plain
    var chipPlacement = ChipPlacement.leading

    @State private var text: String = ""
    @FocusState private var focused: Bool

    /// Initialize a chip text field.
    /// - Parameter titleKey: The localized string key representing the title for this field.
    /// - Parameter chips: The chips that will be edited within this field.
    /// - Parameter submitWithSpaces: Whether a space character should be considered as a submit action.
    public init(
        _ titleKey: LocalizedStringKey,
        chips: Binding<ChipCollection>,
        prompt: LocalizedStringKey? = nil,
        submitWithSpaces: Bool = true
    ) {
        self._chips = chips
        self.title = titleKey
        self.submitWithSpaces = submitWithSpaces
        self.prompt = prompt ?? ""
    }

    init(
        _ titleKey: LocalizedStringKey,
        chips: Binding<ChipCollection>,
        prompt: LocalizedStringKey,
        submitWithSpaces: Bool,
        style: Style,
        chipPlacement: ChipPlacement
    ) {
        self._chips = chips
        self.title = titleKey
        self.prompt = prompt
        self.submitWithSpaces = submitWithSpaces
        self.style = style
        self.chipPlacement = chipPlacement
    }

    /// Configures the chip text field style for the current view.
    /// - Parameter style: The style to apply to this view.
    public func chipTextFieldStyle(_ style: Style) -> Self {
        ChipTextField(
            self.title,
            chips: self.$chips,
            prompt: self.prompt,
            submitWithSpaces: self.submitWithSpaces,
            style: style,
            chipPlacement: self.chipPlacement)
    }

    /// Configures the placement of the chips in the text field.
    /// - Parameter placement: The chip placement to apply to this view.
    public func chipPlacement(_ placement: ChipPlacement) -> Self {
        ChipTextField(
            self.title,
            chips: self.$chips,
            prompt: self.prompt,
            submitWithSpaces: self.submitWithSpaces,
            style: self.style,
            chipPlacement: placement)
    }

    public var body: some View {
        HStack {
            Text(title)
                .layoutPriority(1)
            ScrollView(.horizontal) {
                HStack {
                    
                    if chipPlacement == .leading {
                        chipCollection
                    }
                    TextField("", text: $text, prompt: Text(prompt))
                        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                        .textFieldStyle(.plain)
                        .focused($focused)
                        .layoutPriority(1)
                    if chipPlacement == .trailing {
                        chipCollection
                    }
                }
            }
            .scrollIndicators(.never, axes: .horizontal)
            .if(style == .roundedBorder) { view in
                view.modifier(BorderedChipTextFieldStyle())
            }
            .if(style == .borderless) { view in
                view.modifier(BorderlessChipTextFieldStyle())
            }
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

    private var chipCollection: some View {
        ForEach(Array(chips.sorted()), id: \.self) { chip in
            ChipView(text: chip) {
                chips.remove(chip)
            }
        }
        .layoutPriority(0.25)
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
                    "Tags", chips: $viewModel.chips)
                .chipPlacement(.trailing)
            } header: {
                Text("With Prefilled Content, Trailing Chips")
            }

            Section {
                ChipTextField("", chips: $viewModel.chips, prompt: "Enter a tag...")
                    .chipPlacement(.trailing)
            } header: {
                Text("With Prefilled Content, With Prompt")
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
                Text("With Prefilled Content, Rounded Border")
            }
            Section {
                ChipTextField(
                    "Tags", chips: $viewModel.chips)
                .chipTextFieldStyle(.borderless)
            } header: {
                Text("With Prefilled Content, Borderless")
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
