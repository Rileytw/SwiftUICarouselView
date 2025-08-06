//
//  View+extension.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/7/31.
//

import SwiftUI

// MARK: - Public Methods
public extension View {
    
    /// Enables page indicators with default circular style
    ///
    /// - Parameters:
    ///   - normalColor: Color for unselected indicators (default: gray)
    ///   - selectedColor: Color for selected indicator (default: blue)
    ///   - radius: Raius for circle indicator(default: 4 pt)
    ///   - topPadding: Spacing above indicators (default: 16pt)
    ///   - horizontalInset: Distance indicators are inset from the carousel edges (default: 16pt)
    ///   - background: Optional background styling for indicator container(support capsule and rounded types)
    /// - Returns: Carousel view with page indicators
    func indicator(_ normalColor: Color = .gray, _ selectedColor: Color = .blue, radius: CGFloat = .carouselIndicatorRadius, topPadding: CGFloat = .carouselDefaultPadding, horizontalInset: CGFloat = .carouselDefaultPadding, background: IndicatorBackground? = nil) -> some View {
        self.transformEnvironment(\.carousel) { style in
            style.indicator = Indicator(type: .default(normalColor, selectedColor, radius), topPadding: topPadding, horizontalInset: horizontalInset, background: background)
        }
    }
    
    /// Enables page indicators with custom views
    ///
    /// - Parameters:
    ///   - normal: Custom view for unselected indicators
    ///   - selected: Custom view for selected indicator
    ///   - topPadding: Spacing above indicators (default: 16pt)
    ///   - horizontalInset: Distance indicators are inset from the carousel edges (default: 16pt)
    ///   - background: Optional background styling for indicator container(support capsule and rounded types)
    /// - Returns: Carousel view with custom indicators
    func indicator<N: View, S: View>(normal: N, selected: S, topPadding: CGFloat = .carouselDefaultPadding, horizontalInset: CGFloat = .carouselDefaultPadding,  background: IndicatorBackground? = nil) -> some View {
        self.transformEnvironment(\.carousel) { style in
            style.indicator = Indicator(type: .custom(IndicatorViews(normal: normal, selected: selected)), topPadding: topPadding, horizontalInset: horizontalInset, background: background)
        }
    }
   
    /// Enables page indicators with ViewBuilder closures
    ///
    /// - Parameters:
    ///   - normal: ViewBuilder closure for unselected indicators
    ///   - selected: ViewBuilder closure for selected indicator
    ///   - topPadding: Spacing above indicators (default: 16pt)
    ///   - horizontalInset: Distance indicators are inset from the carousel edges (default: 16pt)
    ///   - background: Optional background styling for indicator container(support capsule and rounded types)
    /// - Returns: Carousel view with dynamic custom indicators
    func indicator<N: View, S: View>(@ViewBuilder normal: @escaping () -> N, @ViewBuilder selected: @escaping () -> S, topPadding: CGFloat = .carouselDefaultPadding, horizontalInset: CGFloat = .carouselDefaultPadding, background: IndicatorBackground? = nil) -> some View {
        self.transformEnvironment(\.carousel) { style in
            style.indicator = Indicator(type: .custom(IndicatorViews(normal: normal, selected: selected)), topPadding: topPadding, horizontalInset: horizontalInset, background: background)
        }
    }
    
    /// Enables scale animation effects for carousel items
    ///
    /// Selected items appear at full size while unselected items are scaled down.
    ///
    /// - Parameter scaleAnimation: Scale animation configuration. Default uses `.easeInOut(duration: 0.3)` animation
    /// - Returns: Carousel view with scale animation effects
    func scaleAnimation(_ scaleAnimation: ScaleAnimation = .default) -> some View {
        self.transformEnvironment(\.carousel) { style in
            style.scaleAnimation = scaleAnimation
        }
    }

    /// Enables infinite loop scrolling for carousel items
    ///
    /// When enabled, the carousel creates seamless infinite scrolling by dynamically
    /// managing duplicate data segments. Users can scroll continuously in either direction
    /// without reaching boundaries.
    ///
    /// - **Returns**: Carousel view with infinite loop scrolling enabled
    func infiniteLoop() -> some View {
        self.transformEnvironment(\.carousel) { style in
            style.isInfiniteLoop = true
        }
    }
}

// MARK: - Internal Methods
extension View {
    func indicatorBackground(_ style: IndicatorBackground?) -> some View {
        modifier(IndicatorBackgroundModifier(style: style))
    }
    
    func capsuleBackground(color: Color = .black.opacity(0.1), padding: EdgeInsets = .carouselDefaultPadding) -> some View {
        self.padding(padding)
            .background(
                Capsule()
                    .fill(color)
            )
    }
    
    func roundedBackground(color: Color = .black.opacity(0.1), cornerRadius: CGFloat = 8, padding: EdgeInsets = .carouselDefaultPadding) -> some View {
        self.padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
            )
    }
    
    func applyScaleAnimation(_ scaleAnimation: ScaleAnimation?, isSelected: Bool, animationValue: Int) -> some View {
        Group {
            if let scaleAnimation = scaleAnimation {
                self.scaleEffect(isSelected ? 1.0 : scaleAnimation.unselectedScale)
                    .animation(scaleAnimation.animation, value: animationValue)
            } else {
                self
            }
        }
    }
    
    func measureSize(_ size: Binding<CGSize>) -> some View {
        modifier(SizeCalculatorModifier(size: size))
    }
}
