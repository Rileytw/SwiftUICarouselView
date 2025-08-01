//
//  IndicatorStyle.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/7/30.
//

import SwiftUI

public enum IndicatorStyle {
    case `default`(Color, Color, IndicatorBackgroundStyle?)
    case custom(IndicatorCustomViews, IndicatorBackgroundStyle?)
}

public struct IndicatorCustomViews {
    let normal: AnyView
    let selected: AnyView
    
    public init<N: View, S: View>(normal: N, selected: S) {
        self.normal = AnyView(normal)
        self.selected = AnyView(selected)
    }
    
    public init<N: View, S: View>(@ViewBuilder normal: () -> N, @ViewBuilder selected: () -> S) {
        self.normal = AnyView(normal())
        self.selected = AnyView(selected())
    }
}
