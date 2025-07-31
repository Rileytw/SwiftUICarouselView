//
//  CarousalConfiguration.swift
//  SwiftUICarousalView
//
//  Created by Lei on 2025/7/29.
//

import Foundation
import SwiftUI

public struct CarousalConfiguration {
    let itemWidth: CGFloat
    let itemHeight: CGFloat
    let itemPadding: CGFloat
    let verticalPadding: CGFloat
    let backgroundColor: Color
    let indicatorStyle: IndicatorStyle?
    
    public init(itemWidth: CGFloat, itemHeight: CGFloat, itemPadding: CGFloat = 16, verticalPadding: CGFloat = 16, backgroundColor: Color = .clear, indicatorStyle: IndicatorStyle? = .default(.gray, .blue)) {
        self.itemWidth = itemWidth
        self.itemHeight = itemHeight
        self.itemPadding = itemPadding
        self.verticalPadding = verticalPadding
        self.backgroundColor = backgroundColor
        self.indicatorStyle = indicatorStyle
    }
}
