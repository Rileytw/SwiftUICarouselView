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
}

private struct IndicatorStyleKey: EnvironmentKey {
    static let defaultValue: IndicatorStyle? = nil
}
