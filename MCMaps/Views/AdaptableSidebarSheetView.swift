//
//  AdaptableSidebarSheetView.swift
//  MCMaps
//
//  Created by Marquis Kurt on 02-02-2025.
//

import SwiftUI

#if os(iOS)
    struct AdaptableSidebarSheetView<Content: View, Sheet: View>: View {
        @Binding private var sheetDisplayed: Bool
        @State private var sheetDisplayedInternally = false
        var preferredSidebarWidthFraction = 0.317
        var content: () -> Content
        var sheet: () -> Sheet

        init(
            preferredSidebarWidthFraction: Double = 0.317, content: @escaping () -> Content,
            sheet: @escaping () -> Sheet
        ) {
            self.sheetDisplayedInternally = false
            self._sheetDisplayed = .init(projectedValue: .constant(false))
            self.preferredSidebarWidthFraction = preferredSidebarWidthFraction
            self.content = content
            self.sheet = sheet
            self._sheetDisplayed = $sheetDisplayedInternally
        }

        init(
            isPresented: Binding<Bool>,
            preferredSidebarWidthFraction: Double = 0.317,
            content: @escaping () -> Content,
            sheet: @escaping () -> Sheet
        ) {
            self._sheetDisplayed = isPresented
            self.preferredSidebarWidthFraction = preferredSidebarWidthFraction
            self.content = content
            self.sheet = sheet
        }

        var body: some View {
            AdaptableSidebarSheetInternalView(
                sheetDisplayed: $sheetDisplayed,
                preferredSidebarWidthFraction: preferredSidebarWidthFraction,
                content: content,
                sheet: sheet
            )
        }
    }

    private struct AdaptableSidebarSheetInternalView<Content: View, Sheet: View>: View {
        enum Breakpoint {
            case small, medium, large
        }
        @State private var currentBreakpoint = Breakpoint.large
        @State private var eligibleToResize = true
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass
        @Binding var sheetDisplayed: Bool

        var preferredSidebarWidthFraction: CGFloat
        var content: () -> Content
        var sheet: () -> Sheet

        private var dragGesture: some Gesture {
            let shorthandMin = 32.0
            let shorthandMax = 48.0
            let longhandMin = 128.0
            let longhandMax = 256.0

            let positiveShorthand = shorthandMin...shorthandMax
            let negativeShorthand = -shorthandMax ... -shorthandMin
            let positiveLonghand = longhandMin...longhandMax
            let negativeLonghand = -longhandMax ... -longhandMin

            return DragGesture(minimumDistance: shorthandMin / 2)
                .onChanged { value in
                    if !eligibleToResize { return }
                    let height = value.translation.height
                    switch (currentBreakpoint, height) {
                    case (.small, positiveShorthand), (.large, negativeShorthand):
                        withAnimation(.spring) {
                            eligibleToResize = false
                            currentBreakpoint = .medium
                        } completion: {
                            eligibleToResize = true
                        }
                    case (.medium, positiveLonghand):
                        withAnimation(.spring) {
                            eligibleToResize = false
                            currentBreakpoint = .large
                        } completion: {
                            eligibleToResize = true
                        }
                    case (.large, negativeLonghand), (.medium, negativeShorthand):
                        withAnimation(.spring) {
                            eligibleToResize = false
                            currentBreakpoint = .small
                        } completion: {
                            eligibleToResize = true
                        }
                    default:
                        break
                    }
                }
        }

        var body: some View {
            Group {
                if horizontalSizeClass == .compact {
                    content()
                } else {
                    sidebarLayout
                }
            }
            .onAppear {
                sheetDisplayed = horizontalSizeClass == .compact
            }
            .onChange(of: horizontalSizeClass) { _, newValue in
                sheetDisplayed = newValue == .compact
            }
            .sheet(isPresented: $sheetDisplayed) {
                sheet()
            }
        }

        private var sidebarLayout: some View {
            GeometryReader { proxy in
                HStack {
                    VStack {
                        VStack {
                            sheet()
                                .frame(maxHeight: height(relativeTo: proxy))
                            Capsule()
                                .fill(.selection)
                                .frame(width: 64, height: 8)
                                .gesture(dragGesture)
                        }
                        .padding(.vertical)
                        .background(Color.systemBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        Spacer()
                    }
                    .frame(width: proxy.size.width * preferredSidebarWidthFraction)
                    .padding()
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .background {
                    content()
                }
            }
        }

        private func height(relativeTo proxy: GeometryProxy) -> CGFloat {
            return switch currentBreakpoint {
            case .small:
                108
            case .medium:
                proxy.size.height * 0.5
            case .large:
                .infinity
            }
        }
    }

    #if DEBUG
        extension AdaptableSidebarSheetView {
            var testHooks: TestHooks { TestHooks(target: self) }

            struct TestHooks {
                private let target: AdaptableSidebarSheetView

                fileprivate init(target: AdaptableSidebarSheetView) {
                    self.target = target
                }

                var sheetDisplayedInternally: Bool {
                    target.sheetDisplayedInternally
                }

                var preferredSidebarWidthFraction: Double {
                    target.preferredSidebarWidthFraction
                }

                var content: () -> Content {
                    target.content
                }

                var sheet: () -> Sheet {
                    target.sheet
                }
            }
        }
    #endif

#endif
