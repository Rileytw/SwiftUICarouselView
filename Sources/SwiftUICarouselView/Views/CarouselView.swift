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
///
/// ## Features
/// - Responsive item sizing based on container width or fixed dimensions
/// - Smooth scroll animations and gesture handling
/// - Customizable spacing, background, and padding
///
/// ## Basic Usage
/// ```swift
/// let items = [
///     CarouselItem(content: AnyView(Text("Item 1"))),
///     CarouselItem(content: AnyView(Text("Item 2"))),
///     CarouselItem(content: AnyView(Text("Item 3")))
/// ]
///
/// CarouselView(
///     itemLayout: ItemLayout(ratio: 16.0/9.0, spacing: 12),
///     dataSource: items
/// )
/// ```
///
/// ## Advanced Usage
/// ```swift
/// CarouselView(
///     itemLayout: ItemLayout(width: 300, ratio: 1.0, spacing: 16),
///     dataSource: items,
///     backgroundColor: .gray.opacity(0.1),
///     padding: EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
/// )
/// .indicator()
/// .scaleAnimation()
/// ```
public struct CarouselView: View {
    @Environment(\.carousel) private var carousel
    
    @State private var itemLayout: ItemLayout
    @State private var itemHeight: CGFloat
    @State private var dataSource: [CarouselItem]
    @State private var currentIndex: Int = 0
    @State private var offset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    @State private var backgroundColor: Color
    @State private var padding: EdgeInsets
    
    public init(itemLayout: ItemLayout, dataSource: [CarouselItem], backgroundColor: Color = .clear, padding: EdgeInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)) {
        self.itemLayout = itemLayout
        self.itemHeight = itemLayout.height
        self.dataSource = dataSource
        self.backgroundColor = backgroundColor
        self.padding = padding
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            carouselView
                .frame(maxWidth: .infinity, maxHeight: itemHeight)
            
            if let indicator = carousel.indicator {
                IndicatorView(currentIndex: $currentIndex, dataSource: $dataSource, indicator: indicator)
                    .padding(.top, indicator.topPadding)
            }
        }
        .padding(padding)
        .background(backgroundColor)
        .clipped()
    }
}

// MARK: - Private Methods
private extension CarouselView {
    @ViewBuilder
    var carouselView: some View {
        GeometryReader { geometry in
            let itemWidth = itemLayout.width ?? geometry.size.width
            
            HStack(spacing: itemLayout.spacing) {
                ForEach(Array(dataSource.enumerated()), id: \.element.id) { index, item in
                    
                    item.view
                        .frame(width: itemWidth)
                        .applyScaleAnimation(carousel.scaleAnimation, isSelected: index == currentIndex, animationValue: currentIndex)
                }
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
                        
                        handleDragEnd(value, itemWidth: itemWidth, spacing: itemLayout.spacing, parentViewWidth: geometry.size.width)
                    }
            )
            .onAppear {
                offset = -(itemWidth + itemLayout.spacing) * CGFloat(currentIndex) + (geometry.size.width - itemWidth) / 2
                itemHeight = itemWidth / itemLayout.ratio
            }
        }
    }
    
    func handleDragEnd(_ value: DragGesture.Value, itemWidth: CGFloat, spacing: CGFloat, parentViewWidth: CGFloat) {
        let itemFullWidth = itemWidth + spacing
        let threshold = itemWidth * 0.3
        
        withAnimation(.easeOut(duration: 0.3)) {
            if abs(value.translation.width) > threshold {
                if value.translation.width > 0 {
                    currentIndex -= 1
                } else {
                    currentIndex += 1
                }
            }
            
            dragOffset = 0
            offset = -itemFullWidth * CGFloat(currentIndex) + (parentViewWidth - itemWidth) / 2
        }
    }
    
    func shouldDisableDrag(_ value: DragGesture.Value) -> Bool {
        let itemCount = dataSource.count
        guard itemCount > 1 else { return true }
        
        let translation = value.translation.width
        return (currentIndex == 0 && translation > 0) || (currentIndex == itemCount - 1 && translation < 0)
    }
}
