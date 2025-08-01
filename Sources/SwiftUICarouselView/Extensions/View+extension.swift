//
//  View+extension.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/7/31.
//

import SwiftUI

// MARK: - Public Methods
public extension View {
    func indicator(_ normalColor: Color = .gray, _ selectedColor: Color = .blue, background: IndicatorBackground? = nil) -> some View {
        self.transformEnvironment(\.carouselStyle) { style in
            style.indicator = Indicator(type: .default(normalColor, selectedColor), background: background)
        }
    }
    
    func indicator<N: View, S: View>(normal: N, selected: S, background: IndicatorBackground? = nil) -> some View {
        self.transformEnvironment(\.carouselStyle) { style in
            style.indicator = Indicator(type: .custom(IndicatorViews(normal: normal, selected: selected)), background: background)
        }
    }
   
    func indicator<N: View, S: View>(@ViewBuilder normal: @escaping () -> N, @ViewBuilder selected: @escaping () -> S, background: IndicatorBackground? = nil) -> some View {
        self.transformEnvironment(\.carouselStyle) { style in
            style.indicator = Indicator(type: .custom(IndicatorViews(normal: normal, selected: selected)), background: background)
        }
    }
    
    func scaleAnimation(_ scaleAnimation: ScaleAnimation = .default) -> some View {
        self.transformEnvironment(\.carouselStyle) { style in
            style.scaleAnimation = scaleAnimation
        }
    }
}

// MARK: - Internal Methods
extension View {
    func indicatorBackground(_ style: IndicatorBackground?) -> some View {
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
