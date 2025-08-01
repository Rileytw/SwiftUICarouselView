//
//  ScaleAnimation.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/8/1.
//

import SwiftUI

public struct ScaleAnimation {
    let unselectedScale: CGFloat
    let animation: Animation
    
    public init(unselectedScale: CGFloat = 0.8, animation: Animation = .easeInOut(duration: 0.3)) {
        self.unselectedScale = unselectedScale
        self.animation = animation
    }
    
    public static let `default` = ScaleAnimation()
}
