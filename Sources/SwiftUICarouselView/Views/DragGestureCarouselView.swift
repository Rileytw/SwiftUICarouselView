//
//  DragGestureCarouselView.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/8/5.
//

import SwiftUI

struct DragGestureCarouselView<Data, Content>: View where Data: RandomAccessCollection, Content: View {
    @Environment(\.carousel) private var carousel
    
    @Binding var selectedIndex: Int
    @Binding var dataSource: Data
    @Binding var dataSourceArray: [Data]
    @Binding var itemSize: CGSize
    @Binding var adjustedItemSpacing: CGFloat
    let content: (Data.Element) -> Content
    @State private var offset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    
    
    var body: some View {
        let itemWidth = itemSize.width
        
        GeometryReader { geometry in
            HStack(spacing: adjustedItemSpacing) {
                ForEach(items, id: \.offset) { index, element in
                    content(element)
                        .frame(width: itemSize.width)
                        .applyScaleAnimation(carousel.scaleAnimation, isSelected: index == selectedIndex, animationValue: selectedIndex)
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
                        
                        handleDragEnd(value, itemWidth: itemWidth, spacing: adjustedItemSpacing, parentViewWidth: geometry.size.width)
                    }
            )
            .onAppear {
                offset = -(itemWidth + adjustedItemSpacing) * CGFloat(selectedIndex) + (geometry.size.width - itemWidth) / 2
            }
        }
    }
}

// MARK: - Private Methods
private extension DragGestureCarouselView {
    var items: [EnumeratedSequence<Data>.Element] {
       return carousel.isInfiniteLoop ? Array(dataSourceArray.flatMap { $0 }.enumerated()) : Array(dataSource.enumerated())
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
