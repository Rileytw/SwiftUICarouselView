//
//  ItemLayout.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/7/29.
//

import Foundation
import SwiftUI

public struct ItemLayout {
    let size: CGSize
    let spacing: CGFloat
    
   public init(size: CGSize, spacing: CGFloat = 16) {
        self.size = size
        self.spacing = spacing
    }
}
