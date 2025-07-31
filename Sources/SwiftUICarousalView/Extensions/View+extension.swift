//
//  View+extension.swift
//  SwiftUICarousalView
//
//  Created by Lei on 2025/7/31.
//

import SwiftUI

// MARK: - Public Methods
public extension View {
    func indicatorEnabled(_ normalColor: Color = .gray, _ selectedColor: Color = .blue, backgroundStyle: IndicatorBackgroundStyle? = nil) -> some View {
        self.transformEnvironment(\.carousalStyle) { style in
            style.indicatorStyle = .default(normalColor, selectedColor, backgroundStyle)
        }
    }
    
    func indicatorEnabled<N: View, S: View>(normal: N, selected: S, backgroundStyle: IndicatorBackgroundStyle? = nil) -> some View {
        self.transformEnvironment(\.carousalStyle) { style in
            style.indicatorStyle = .custom(IndicatorCustomViews(normal: normal, selected: selected), backgroundStyle)
        }
    }
   
    func indicatorEnabled<N: View, S: View>(@ViewBuilder normal: @escaping () -> N, @ViewBuilder selected: @escaping () -> S, backgroundStyle: IndicatorBackgroundStyle? = nil) -> some View {
        self.transformEnvironment(\.carousalStyle) { style in
            style.indicatorStyle = .custom(IndicatorCustomViews(normal: normal, selected: selected), backgroundStyle)
        }
    }
    
    func scaleEffectEnabled(_ scaleStyle: ScaleAnimationStyle = .default) -> some View {
        self.transformEnvironment(\.carousalStyle) { style in
            style.scaleAnimationStyle = scaleStyle
        }
    }
}

// MARK: - Internal Methods
extension View {
    func indicatorBackground(_ style: IndicatorBackgroundStyle?) -> some View {
        modifier(IndicatorBackgroundModifier(style: style))
    }
    
    func capsuleBackground(color: Color = .black.opacity(0.1), padding: EdgeInsets = EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)) -> some View {
        self.padding(padding)
            .background(
                Capsule()
                    .fill(color)
            )
    }
    
    func roundedBackground(color: Color = .black.opacity(0.1), cornerRadius: CGFloat = 8, padding: EdgeInsets = EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)) -> some View {
        self.padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
            )
    }
}
