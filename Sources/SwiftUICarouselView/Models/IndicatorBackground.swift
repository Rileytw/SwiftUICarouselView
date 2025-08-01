//
//  IndicatorBackground.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/7/31.
//

import SwiftUI

public enum IndicatorBackground {
    case capsule(Color, EdgeInsets)
    case rounded(Color, EdgeInsets, CGFloat)
    
    public static func capsule(color: Color = .black.opacity(0.1), padding: EdgeInsets = EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)) -> IndicatorBackground {
        return .capsule(color, padding)
    }
    
    public static func rounded(color: Color = .black.opacity(0.1), padding: EdgeInsets = EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12), cornerRadius: CGFloat = 8) -> IndicatorBackground {
        return .rounded(color, padding, cornerRadius)
    }
}

// MARK: - Public Methods
public extension IndicatorBackground {
    var padding: EdgeInsets {
        switch self {
        case .capsule(_, let edgeInsets):
            return edgeInsets
        case .rounded(_, let edgeInsets, _):
            return edgeInsets
        }
    }
    
    var color: Color {
        switch self {
        case .capsule(let color, _):
            return color
        case .rounded(let color, _, _):
            return color
        }
    }
}
