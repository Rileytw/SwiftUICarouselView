//
//  CarousalConfiguration.swift
//  SwiftUICarousalView
//
//  Created by Lei on 2025/7/29.
//

import Foundation

public struct CarousalConfiguration {
    let itemWidth: CGFloat
    let itemPadding: CGFloat
    let withPageControl: Bool
    let verticalPadding: CGFloat
    
    public init(itemWidth: CGFloat, itemPadding: CGFloat = 16, withPageControl: Bool = true, verticalPadding: CGFloat = 8) {
        self.itemWidth = itemWidth
        self.itemPadding = itemPadding
        self.withPageControl = withPageControl
        self.verticalPadding = verticalPadding
    }
}
