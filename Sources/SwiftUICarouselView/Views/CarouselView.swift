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
/// - **Flexible Styling**: Support for indicators, scale animations, and custom spacing
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
    
    @Binding var selectedIndex: Int
    let content: (Data.Element) -> Content
    @State private var dataSource: Data
    @State private var itemSpacing: CGFloat
    @State private var itemSize: CGSize = .zero
    @State private var offset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    @State private var size: CGSize = .zero
    @State private var centeredViewID: Int?
    
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
    
    @ViewBuilder
    var carouselView: some View {
        if #available(iOS 17.0, *) {
            scrollCarouselView
        } else {
            dragGestureCarouselView
        }
    }
    
    @available (iOS 17.0, *)
    @ViewBuilder
    var scrollCarouselView: some View {
        GeometryReader {  geometry in
            let itemWidth = itemSize.width
            let horizontlMargin = (geometry.size.width - itemWidth) / 2
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: itemSpacing) {
                    itemsView
                }
                .scrollTargetLayout()
            }
            .contentMargins(.horizontal, horizontlMargin)
            .scrollPosition(id: $centeredViewID, anchor: .center)
            .scrollTargetBehavior(.viewAligned)
            .onChange(of: centeredViewID) { _, newValue in
                guard let newIndex = newValue else {
                    return
                }
                selectedIndex = newIndex
            }
        }
    }
    
    @ViewBuilder
    var dragGestureCarouselView: some View {
        let itemWidth = itemSize.width
        
        GeometryReader { geometry in
            HStack(spacing: itemSpacing) {
                itemsView
            }
            .offset(x: offset + dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        guard !shouldDisableDrag(value) else {
                            return
                        }
                        
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        guard !shouldDisableDrag(value) else {
                            return
                        }
                        
                        handleDragEnd(value, itemWidth: itemWidth, spacing: itemSpacing, parentViewWidth: geometry.size.width)
                    }
            )
            .onAppear {
                offset = -(itemWidth + itemSpacing) * CGFloat(selectedIndex) + (geometry.size.width - itemWidth) / 2
            }
        }
    }
    
    @ViewBuilder
    var itemsView: some View {
        ForEach(Array(dataSource.enumerated()), id: \.offset) { index, element in
            content(element)
                .frame(width: itemSize.width)
                .applyScaleAnimation(carousel.scaleAnimation, isSelected: index == selectedIndex, animationValue: selectedIndex)
                .id(index)
        }
    }
    
    @ViewBuilder
    var measurementView: some View {
        if let firstElement = dataSource.first {
            content(firstElement)
                .measureSize($itemSize)
        }
    }
    
    func handleDragEnd(_ value: DragGesture.Value, itemWidth: CGFloat, spacing: CGFloat, parentViewWidth: CGFloat) {
        let itemFullWidth = itemWidth + spacing
        let threshold = itemWidth * 0.3
        
        withAnimation(.easeOut(duration: 0.3)) {
            if abs(value.translation.width) > threshold {
                if value.translation.width > 0 {
                    selectedIndex =  max(0, selectedIndex - 1)
                } else {
                    selectedIndex = min(dataSource.count - 1, selectedIndex + 1)
                }
            }
            
            dragOffset = 0
            offset = -itemFullWidth * CGFloat(selectedIndex) + (parentViewWidth - itemWidth) / 2
        }
    }
    
    func shouldDisableDrag(_ value: DragGesture.Value) -> Bool {
        let itemCount = dataSource.count
        guard itemCount > 1 else { return true }
        return (selectedIndex == 0 && value.isScrollToRight) || (selectedIndex == itemCount - 1 && value.isScrollToLeft)
    }
}
