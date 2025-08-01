//
//  IndicatorBackgroundModifier.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/7/31.
//

import SwiftUI

public struct IndicatorBackgroundModifier: ViewModifier {
    let style: IndicatorBackground?
    
    public func body(content: Content) -> some View {
        if let style = style {
            switch style {
            case .capsule(let color, let padding):
                content
                    .capsuleBackground(color: color, padding: padding)
            case .rounded(let color, let padding, let cornerRadius):
                content
                    .roundedBackground(color: color, cornerRadius: cornerRadius, padding: padding)
            }
        } else {
            content
        }
    }
}
