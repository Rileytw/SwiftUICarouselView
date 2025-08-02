//
//  DragGestureValue+extension.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/8/2.
//

import SwiftUI

extension DragGesture.Value {
    private static let minimumDragDistance: CGFloat = 10
    
    var isScrollToLeft: Bool {
        return translation.width < -Self.minimumDragDistance
    }
    
    var isScrollToRight: Bool {
        return translation.width > Self.minimumDragDistance
    }
}
