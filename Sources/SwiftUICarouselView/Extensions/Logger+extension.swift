//
//  Logger+extension.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/8/4.
//

import OSLog

extension Logger {
    private static var subsystem = "swiftUICarouselView"
    
    static let carouselView = Logger(subsystem: subsystem, category: "CarouselView")
}
