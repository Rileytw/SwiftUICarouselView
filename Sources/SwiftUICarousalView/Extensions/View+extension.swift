//
//  View+extension.swift
//  SwiftUICarousalView
//
//  Created by Lei on 2025/7/31.
//

import SwiftUI

extension View {
    func indicatorBackground(_ style: IndicatorBackgroundStyle?) -> some View {
        modifier(IndicatorBackgroundModifier(style: style))
    }
    
    func capsuleBackground(color: Color = .black.opacity(0.1), padding: EdgeInsets = EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)) -> some View {
        self
            .padding(padding)
            .background(
                Capsule()
                    .fill(color)
            )
    }
    
    func roundedBackground(color: Color = .black.opacity(0.1), cornerRadius: CGFloat = 8, padding: EdgeInsets = EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)) -> some View {
        self
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
            )
    }
    
}
