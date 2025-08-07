//
//  AutoPlay.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/8/7.
//

import Foundation

public struct AutoPlay {
    /// Time interval between automatic transitions (in seconds)
    public let interval: TimeInterval
    
    /// Auto-play direction
    public let direction: AutoPlayDirection
    
    public init(interval: TimeInterval = 3.0, direction: AutoPlayDirection = .forward) {
        self.interval = interval
        self.direction = direction
    }
    
    public static let `default` = AutoPlay()
}

public enum AutoPlayDirection {
    case forward
    case backward
}
