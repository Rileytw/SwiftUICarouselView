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
    var scaleAnimation: ScaleAnimation?
    
    public init(indicator: Indicator? = nil, scaleAnimation: ScaleAnimation? = nil) {
        self.indicator = indicator
        self.scaleAnimation = scaleAnimation
    }
}


