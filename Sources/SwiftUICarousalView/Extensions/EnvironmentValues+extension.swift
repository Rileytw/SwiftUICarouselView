//
//  EnvironmentValues+extension.swift
//  SwiftUICarousalView
//
//  Created by Lei on 2025/7/31.
//

import SwiftUI

extension EnvironmentValues {
    var indicatorStyle: IndicatorStyle? {
        get { self[IndicatorStyleKey.self] }
        set { self[IndicatorStyleKey.self] = newValue }
    }
    
    var scaleAnimationStyle: ScaleAnimationStyle? {
        get { self[ScaleAnimationStyleKey.self] }
        set { self[ScaleAnimationStyleKey.self] = newValue }
    }
}

private struct IndicatorStyleKey: EnvironmentKey {
    static let defaultValue: IndicatorStyle? = nil
}

private struct ScaleAnimationStyleKey: EnvironmentKey {
    static let defaultValue: ScaleAnimationStyle? = nil
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
