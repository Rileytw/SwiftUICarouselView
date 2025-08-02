//
//  ItemLayout.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/7/29.
//

import Foundation
import SwiftUI

/// Defines the layout configuration for carousel items
///
/// `ItemLayout` configures the dimensions and spacing of carousel items. It supports
/// both fixed width and automatic width adaptation to the parent view, and calculates
/// item height through aspect ratio.
///
/// ## Width Calculation Rules
/// - When `width` is `nil`, the item width automatically adapts to the parent view (container) width
/// - When `width` has a value, the specified fixed width is used
///
/// ## Height Calculation
/// Item height = Item width ÷ `ratio`
///
/// ## Usage Examples
/// ```swift
/// // Auto width with 16:9 aspect ratio
/// let layout1 = ItemLayout(ratio: 16.0/9.0, spacing: 12)
///
/// // Fixed 300pt width with 4:3 aspect ratio
/// let layout2 = ItemLayout(width: 300, ratio: 4.0/3.0, spacing: 16)
///
/// // Square items with auto width
/// let layout3 = ItemLayout(ratio: 1.0, spacing: 8)
/// ```
public struct ItemLayout {
    /// Item width. `nil` for auto-adapting to parent view width
    let width: CGFloat?
    
    /// Aspect ratio (width ÷ height)
    ///
    /// Examples: `16.0/9.0` for 16:9 widescreen, `1.0` for square
    let ratio: CGFloat
    
    /// Defines the horizontal spacing between adjacent items
    let spacing: CGFloat
    
    /// Creates an item layout configuration
    ///
    /// - Parameters:
    ///   - width: Item width. `nil` means auto-adapt to parent view width, defaults to `nil`
    ///   - ratio: Aspect ratio (width ÷ height), must be greater than 0
    ///   - spacing: Item spacing in points
    ///
    /// - Precondition: `ratio` must be greater than 0
    /// - Precondition: `spacing` should be non-negative
    ///
    /// ## Usage Recommendations
    /// - For responsive design, recommend using `width: nil`
    /// - For fixed layout, specify a concrete `width` value
    ///
    /// ```swift
    /// // Responsive layout
    /// let responsiveLayout = ItemLayout(ratio: 16.0/9.0, spacing: 12)
    ///
    /// // Fixed width layout
    /// let fixedLayout = ItemLayout(width: 320, ratio: 1.0, spacing: 16)
    /// ```
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
