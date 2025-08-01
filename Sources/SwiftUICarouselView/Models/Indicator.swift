//
//  Indicator.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/8/1.
//

import Foundation

public struct Indicator {
    let type: IndicatorType
    let background: IndicatorBackground?
    
    public init(type: IndicatorType, background: IndicatorBackground? = nil) {
        self.type = type
        self.background = background
    }
}
