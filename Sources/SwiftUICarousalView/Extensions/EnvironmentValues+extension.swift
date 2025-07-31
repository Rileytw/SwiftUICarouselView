//
//  EnvironmentValues+extension.swift
//  SwiftUICarousalView
//
//  Created by Lei on 2025/7/31.
//

import SwiftUI

extension EnvironmentValues {
    var carousalStyle: CarousalStyle {
        get { self[CarousalStyleKey.self] }
        set { self[CarousalStyleKey.self] = newValue }
    }
}

private struct CarousalStyleKey: EnvironmentKey {
    static let defaultValue: CarousalStyle = CarousalStyle()
}

public struct CarousalStyle {
    var indicatorStyle: IndicatorStyle?
    var scaleAnimationStyle: ScaleAnimationStyle?
    
    public init(indicatorStyle: IndicatorStyle? = nil, scaleAnimationStyle: ScaleAnimationStyle? = nil) {
        self.indicatorStyle = indicatorStyle
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
