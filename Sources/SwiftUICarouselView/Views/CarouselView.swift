//
//  CarouselView.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/7/29.
//

import SwiftUI

/// A customizable carousel view for displaying a horizontal scrolling collection of items
///
/// `CarouselView` provides a smooth, interactive carousel experience with support for
/// automatic sizing, custom layouts, and responsive design. Items can be navigated
/// through touch gestures with optional indicators and animations.
/// The carousel automatically measures the first item's size to determine the optimal height,
/// ensuring a perfect fit without manual ratio calculations.
///
/// ## Features
/// - **Automatic Height Calculation**: Measures content size dynamically for perfect fit
/// - **Generic Data Support**: Works with any `RandomAccessCollection` items
/// - **Responsive Design**: Adapts to container width while maintaining content proportions
/// - **Smooth Interactions**: Gesture-based navigation with customizable animations
/// - **Flexible Styling**: Support for indicators, scale animations, ininite scrolling, and custom spacing
///
/// ## Basic Usage
/// ```swift
/// @State private var selectedIndex = 0
/// let cards: [Card] = [
///     Card(title: "Card 1", content: "Content of card 1"),
///     Card(title: "Card 2", content: "Content of card 2"),
///     Card(title: "Card 3", content: "Content of card 3"),
///     Card(title: "Card 4", content: "Content of card 4")
///     ]
///
/// CarouselView(cards, selectedIndex: $selectedIndex) { card in
///     CardView(card)
/// }
/// .indicator()
/// .scaleAnimation()
/// ```
///
/// ## Advanced Usage
/// ```swift
/// CarouselView(products, selectedIndex: $selectedProduct, itemSpacing: 24) { product in
///     ProductCardView(product: product)
///         .frame(width: 280)
///         .background(Color.white)
///         .cornerRadius(16)
///         .shadow(radius: 8)
/// }
/// .indicator(.gray.opacity(0.4), .blue, topPadding: 20)
/// .scaleAnimation()
/// .infiniteLoop()
/// ```
///
/// ## Custom Spacing and Indicators
/// ```swift
/// CarouselView(items, selectedIndex: $index, itemSpacing: 32) { item in
///     CustomItemView(item: item)
/// }
/// .indicator(
///     normal: Circle().fill(.gray).frame(width: 6, height: 6),
///     selected: Circle().fill(.blue).frame(width: 10, height: 10)
/// )
/// .scaleAnimation()
/// ```
public struct CarouselView<Data, Content>: View where Data: RandomAccessCollection, Content: View {
    @Environment(\.carousel) private var carousel
    @State private var autoPlayManager = CarouselAutoPlayManager()
    
    @Binding var selectedIndex: Int
    let content: (Data.Element) -> Content
    @State private var dataSource: Data
    @State private var itemSpacing: CGFloat
    @State private var itemSize: CGSize = .zero
    @State private var offset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    @State private var size: CGSize = .zero
    
    public init(_ dataSource: Data, selectedIndex: Binding<Int>, itemSpacing: CGFloat = .carouselDefaultSpacing, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.dataSource = dataSource
        self._selectedIndex = selectedIndex
        self.content = content
        self.itemSpacing = itemSpacing
        
        CarouselViewLogger.logIndexWarningIfNeeded(dataSourceCount: dataSource.count, selected: selectedIndex.wrappedValue)
    }
    
    public var body: some View {
        Group {
            if isItemSizeMeasured {
                VStack(spacing: 0) {
                    carouselView
                        .frame(maxWidth: .infinity, maxHeight: itemSize.height)
                    
                    if let indicator = carousel.indicator {
                        IndicatorView(selectedIndex: $selectedIndex, dataSource: $dataSource, containerSize: $size, indicator: indicator)
                            .padding(.top, indicator.topPadding)
                    }
                }
                .clipped()
                .measureSize($size)
            } else {
                measurementView
                    .opacity(0)
            }
        }
        .onChange(of: itemSize) { itemSize in
            CarouselViewLogger.logItemSize(itemSize)
        }
        .onChange(of: selectedIndex) { index in
            CarouselViewLogger.logIndexWarningIfNeeded(dataSourceCount: dataSource.count, selected: index)
        }
    }
}

// MARK: - Private Methods
private extension CarouselView {
    var isItemSizeMeasured: Bool {
        return itemSize != .zero
    }
    
    var adjustedItemSpacing: CGFloat {
        guard let scaleAnimation = carousel.scaleAnimation else {
            return itemSpacing
        }
        
        let scaleReduction = (itemSize.width - itemSize.width * scaleAnimation.unselectedScale) / 2
        let compensatedSpacing = itemSpacing - scaleReduction
        
        return min(itemSpacing, compensatedSpacing)
    }
    
    @ViewBuilder
    var carouselView: some View {
        if #available(iOS 17.0, *) {
            ScrollCarouselView(
                selectedIndex: $selectedIndex,
                dataSource: $dataSource,
                itemSize: $itemSize,
                adjustedItemSpacing: Binding(
                    get: { adjustedItemSpacing },
                    set: { _ in }
                ),
                content: content)
            .environmentObject(autoPlayManager)
        } else {
            DragGestureCarouselView(
                selectedIndex: $selectedIndex,
                dataSource: $dataSource,
                itemSize: $itemSize,
                adjustedItemSpacing: Binding(
                    get: { adjustedItemSpacing },
                    set: { _ in }
                ),
                content: content)
            .environmentObject(autoPlayManager)
        }
    }
    
    @ViewBuilder
    var measurementView: some View {
        if let firstElement = dataSource.first {
            content(firstElement)
                .measureSize($itemSize)
        }
    }
}
