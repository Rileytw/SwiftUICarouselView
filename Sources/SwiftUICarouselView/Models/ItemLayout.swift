//
//  ItemLayout.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/7/29.
//

import Foundation
import SwiftUI

public struct ItemLayout {
    let width: CGFloat?
    let ratio: CGFloat
    let spacing: CGFloat
    
    public init(width: CGFloat? = nil, ratio: CGFloat, spacing: CGFloat) {
        self.width = width
        self.ratio = ratio
        self.spacing = spacing
    }
}

// MARK: Internal Methods
extension ItemLayout {
    var height: CGFloat {
       guard let width else {
            return 0
        }
        return width / ratio
    }
}
