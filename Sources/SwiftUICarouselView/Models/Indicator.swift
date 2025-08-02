//
//  Indicator.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/8/1.
//

import Foundation

public struct Indicator {
    let type: IndicatorType
    let topPadding: CGFloat
    let horizontalInset: CGFloat
    let background: IndicatorBackground?
    
    public init(type: IndicatorType, topPadding: CGFloat = 16, horizontalInset: CGFloat = 16, background: IndicatorBackground? = nil, ) {
        self.type = type
        self.topPadding = topPadding
        self.horizontalInset = horizontalInset
        self.background = background
    }
}
