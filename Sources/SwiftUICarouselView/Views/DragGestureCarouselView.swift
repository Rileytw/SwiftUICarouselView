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
    @Binding var itemSize: CGSize
    @Binding var adjustedItemSpacing: CGFloat
    let content: (Data.Element) -> Content
    @State private var offset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    
    
    var body: some View {
        let itemWidth = itemSize.width
        
        GeometryReader { geometry in
            ZStack() {
                ForEach(Array(dataSource.enumerated()), id: \.offset) { index, element in
                    content(element)
                        .frame(width: itemSize.width)
                        .applyScaleAnimation(carousel.scaleAnimation, isSelected: index == selectedIndex, animationValue: selectedIndex)
                        .offset(x: getOffset(index: index))
                }
            }
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
                updateOffset(parentViewWidth: geometry.size.width)
            }
        }
    }
}

// MARK: - Private Methods
private extension DragGestureCarouselView {
    func getOffset(index: Int) -> CGFloat {
        let itemWidth = itemSize.width
        return (itemWidth + adjustedItemSpacing) * CGFloat(index) + offset + dragOffset
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
            
            updateOffset(parentViewWidth: parentViewWidth)
        }
    }
    
    func updateOffset(parentViewWidth: CGFloat) {
        let itemWidth = itemSize.width
        let itemFullWidth = itemWidth + adjustedItemSpacing
        offset = -itemFullWidth * CGFloat(selectedIndex) + (parentViewWidth - itemWidth) / 2
        dragOffset = 0
    }
    
    func shouldDisableDrag(_ value: DragGesture.Value) -> Bool {
        let itemCount = dataSource.count
        guard itemCount > 1 else { return true }
        return (selectedIndex == 0 && value.isScrollToRight) || (selectedIndex == itemCount - 1 && value.isScrollToLeft)
    }
}
