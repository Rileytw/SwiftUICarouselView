//
//  EnvironmentValues+extension.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/7/31.
//

import SwiftUI

extension EnvironmentValues {
    var carouselStyle: CarouselStyle {
        get { self[CarouselStyleKey.self] }
        set { self[CarouselStyleKey.self] = newValue }
    }
}

private struct CarouselStyleKey: EnvironmentKey {
    static let defaultValue: CarouselStyle = CarouselStyle()
}

public struct CarouselStyle {
    var indicator: Indicator?
    var scaleAnimationStyle: ScaleAnimationStyle?
    
    public init(indicator: Indicator? = nil, scaleAnimationStyle: ScaleAnimationStyle? = nil) {
        self.indicator = indicator
        self.scaleAnimationStyle = scaleAnimationStyle
    }
}

public struct ScaleAnimationStyle {
    public let unselectedScale: CGFloat
    public let animationDuration: Double
    
    public init(unselectedScale: CGFloat = 0.8, animationDuration: Double = 0.3, ) {
        self.unselectedScale = unselectedScale
        self.animationDuration = animationDuration
    }
    
    public static let `default` = ScaleAnimationStyle()
}
