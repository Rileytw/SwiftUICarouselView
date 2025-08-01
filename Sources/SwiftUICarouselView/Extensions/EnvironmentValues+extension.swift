//
//  EnvironmentValues+extension.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/7/31.
//

import SwiftUI

extension EnvironmentValues {
    var carousel: Carousel {
        get { self[CarouselKey.self] }
        set { self[CarouselKey.self] = newValue }
    }
}

private struct CarouselKey: EnvironmentKey {
    static let defaultValue: Carousel = Carousel()
}

public struct Carousel {
    var indicator: Indicator?
    var scaleAnimation: ScaleAnimation?
    
    public init(indicator: Indicator? = nil, scaleAnimation: ScaleAnimation? = nil) {
        self.indicator = indicator
        self.scaleAnimation = scaleAnimation
    }
}


