//
//  CarouselView.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/7/29.
//

import SwiftUI

public struct CarouselView: View {
    @Environment(\.carousel) private var carousel
    
    @State private var itemLayout: ItemLayout
    @State private var dataSource: [CarouselItem]
    @State private var currentIndex: Int = 0
    @State private var offset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    @State private var backgroundColor: Color
    
    public init(itemLayout: ItemLayout, dataSource: [CarouselItem], backgroundColor: Color = .clear) {
        self.itemLayout = itemLayout
        self.dataSource = dataSource
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            carouselView
                .frame(maxWidth: .infinity, maxHeight: itemLayout.size.height)
            
            if let indicator = carousel.indicator {
                IndicatorView(currentIndex: $currentIndex, dataSource: $dataSource, indicator: indicator)
                    .padding(.top, indicator.topPadding)
            }
        }
        .background(backgroundColor)
        .padding()
        .clipped()
    }
}

// MARK: - Private Methods
private extension CarouselView {
    @ViewBuilder
    var carouselView: some View {
        GeometryReader { geometry in
            let itemWidth = itemLayout.size.width
            
            HStack(spacing: itemLayout.spacing) {
                ForEach(Array(dataSource.enumerated()), id: \.element.id) { index, item in
                    if let scaleAnimation = carousel.scaleAnimation {
                        item.view
                            .frame(width: itemWidth)
                            .scaleEffect(index == currentIndex ? 1.0 : scaleAnimation.unselectedScale)
                            .animation(scaleAnimation.animation, value: currentIndex)
                    } else {
                        item.view
                            .frame(width: itemWidth)
                    }
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
