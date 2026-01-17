//
//  InlineBannerLabelStyle.swift
//  AlidadeUI
//
//  Created by Marquis Kurt on 26-05-2025.
//

import SwiftUI

struct InlineBannerLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .firstTextBaseline) {
            configuration.icon
            VStack(alignment: .leading) {
                configuration.title
            }
        }
    }
}

extension LabelStyle where Self == InlineBannerLabelStyle {
    static var inlineBanner: InlineBannerLabelStyle { InlineBannerLabelStyle() }
}
