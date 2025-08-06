//
//  CarouselViewLogger.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/8/4.
//

import OSLog

struct CarouselViewLogger {
    static func logIndexWarningIfNeeded(dataSourceCount: Int, selected index: Int) {
    #if DEBUG
        guard dataSourceCount > 0 else {
            warning(message: "Cannot set selectedIndex (\(index)) - dataSource is empty")
            return
        }
        
        let validRange = 0..<dataSourceCount
        
        if !validRange.contains(index) {
            let clampedIndex = max(0, min(index, dataSourceCount - 1))
            warning(message: "Selected index (\(index)) is out of valid range \(validRange). Use \(clampedIndex) instead.")
        }
    #endif
    }
    
    static func logItemSize(_ itemSize: CGSize) {
    #if DEBUG
        debug(message: "itemSize updated to: \(itemSize)")
    #endif
    }
}

// MARK: - Private Methods
private extension CarouselViewLogger {
    static func debug(message: String) {
        Logger.carouselView.debug("[SwiftUICarouselView Debug]: \(message)")
    }
    
    static func warning(message: String) {
        Logger.carouselView.warning("[SwiftUICarouselView Warning]: \(message)")
    }
}
