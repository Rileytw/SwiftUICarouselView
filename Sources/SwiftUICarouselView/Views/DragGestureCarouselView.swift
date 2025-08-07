//
//  DragGestureCarouselView.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/8/5.
//

import SwiftUI

struct DragGestureCarouselView<Data, Content>: View where Data: RandomAccessCollection, Content: View {
    @Environment(\.carousel) private var carousel
    @EnvironmentObject var autoPlayManager: CarouselAutoPlayManager
    @GestureState private var dragOffset: CGFloat = .zero
    
    @Binding var selectedIndex: Int
    @Binding var dataSource: Data
    @Binding var itemSize: CGSize
    @Binding var adjustedItemSpacing: CGFloat
    let content: (Data.Element) -> Content
    @State private var carouselLocation = 0
    @State private var containerViewSize: CGSize = .zero
    
    var body: some View {
        ZStack {
            ForEach(Array(dataSource.enumerated()), id: \.offset) { index, element in
                if let positions = getItemPositions(for: index) {
                    ForEach(Array(positions.enumerated()), id: \.offset) { positionIndex, offsetX in
                        content(element)
                            .frame(width: itemSize.width, height: itemSize.height)
                            .applyScaleAnimation(carousel.scaleAnimation, isSelected: index == selectedIndex, animationValue: selectedIndex)
                            .offset(x: offsetX)
                            .id("\(index)_\(positionIndex)")
                    }
                }
            }
        }
        .measureSize($containerViewSize)
        .gesture(
            DragGesture()
                .updating($dragOffset) { drag, offset, _ in
                    offset = drag.translation.width
                }
                .onEnded(handleDragEnd)
        )
        .onChange(of: carouselLocation, perform: { _ in
            let itemCount = dataSource.count
            selectedIndex = (carouselLocation % itemCount + itemCount) % itemCount
        })
        .onReceive(autoPlayManager.$shouldMoveNext, perform: { shouldMoveNext in
            if shouldMoveNext {
                autoPlayToNextItem()
            }
        })
        .onAppear {
            carouselLocation = selectedIndex
            
            if let autoPlay = carousel.autoPlay {
                autoPlayManager.configure(autoPlay)
                autoPlayManager.start()
            }
        }
        .onDisappear {
            autoPlayManager.stop()
        }
    }
}

// MARK: - Private Methods
private extension DragGestureCarouselView {
    func handleDragEnd(drag: DragGesture.Value) {
        guard !shouldDisableDrag(drag) else {
            return
        }
        let threshold = itemSize.width * 0.3
        
        if drag.translation.width > threshold {
            carouselLocation -= 1
        } else if drag.translation.width < -threshold {
            carouselLocation += 1
        }
    }
    
    var displayLocation: Int {
        let itemCount = dataSource.count
        let maxValue: CGFloat = 10000
        return ((itemCount * Int(maxValue)) + carouselLocation) % itemCount
    }
    
    func getOffset(_ index: Int) -> CGFloat? {
        let itemCount = dataSource.count
        let itemWidth = itemSize.width
        let itemFullWidth = itemWidth + adjustedItemSpacing
        
        if carousel.isInfiniteLoop {
            return getInfiniteLoopOffset(for: index, itemFullWidth: itemFullWidth)
        } else {
            let distanceFromSelected = index - carouselLocation
            return dragOffset + (CGFloat(distanceFromSelected) * itemFullWidth)
        }
    }

    func getItemPositions(for index: Int) -> [CGFloat]? {
        let itemCount = dataSource.count
        let itemWidth = itemSize.width
        let itemFullWidth = itemWidth + adjustedItemSpacing
        
        guard carousel.isInfiniteLoop else {
            if let offset = getOffset(index) {
                return [offset]
            }
            return nil
        }
        
        var positions: [CGFloat] = []
        let visibleRange = Int(ceil(containerViewSize.width / itemFullWidth)) + 2
        
        let mainDistance = calculateCircularDistance(from: displayLocation, to: index)
        let mainPosition = dragOffset + (CGFloat(mainDistance) * itemFullWidth)
        
        if shouldAddWrappedPositions(for: index, mainPosition: mainPosition, itemFullWidth: itemFullWidth, visibleRange: visibleRange) {
            let leftWrapPosition = mainPosition - (CGFloat(itemCount) * itemFullWidth)
            let rightWrapPosition = mainPosition + (CGFloat(itemCount) * itemFullWidth)

            let closestPosition = selectClosestPositionToCenter([mainPosition, leftWrapPosition, rightWrapPosition])
            
            positions.append(closestPosition)
        } else {
            positions.append(mainPosition)
        }
        
        return positions.isEmpty ? nil : positions
    }
    
    func selectClosestPositionToCenter(_ candidatePositions: [CGFloat]) -> CGFloat {
        guard !candidatePositions.isEmpty else {
            return .zero
        }
        
        let centerX: CGFloat = 0
        let positionsWithDistances = candidatePositions.map { position in
            (position: position, distance: abs(position - centerX))
        }.sorted { $0.distance < $1.distance }
        
        return positionsWithDistances.first?.position ?? .zero
    }
    
    func shouldAddWrappedPositions(for index: Int, mainPosition: CGFloat, itemFullWidth: CGFloat, visibleRange: Int) -> Bool {
        let itemCount = dataSource.count
        guard itemCount <= 6 else {
            return false
        }
        
        let leftBound = -containerViewSize.width / 2 - itemFullWidth
        let rightBound = containerViewSize.width / 2 + itemFullWidth
        return mainPosition < leftBound || mainPosition > rightBound
    }
    
    func getInfiniteLoopOffset(for index: Int, itemFullWidth: CGFloat) -> CGFloat? {
        let distance = calculateCircularDistance(from: displayLocation, to: index)
        let maxVisibleDistance = getMaxVisibleDistance()
        guard abs(distance) <= maxVisibleDistance else {
            return nil
        }
        
        return dragOffset + (CGFloat(distance) * itemFullWidth)
    }
    
    func getMaxVisibleDistance() -> Int {
        let itemCount = dataSource.count
        let containerCapacity = calculateContainerCapacity()
        let idealVisibleCount = min(containerCapacity, itemCount)
        return max(1, idealVisibleCount / 2)
    }
    
    func calculateContainerCapacity() -> Int {
        let containerWidth = containerViewSize.width
        let itemFullWidth = itemSize.width + adjustedItemSpacing
        return Int(ceil(containerWidth / itemFullWidth)) + 2
    }
    
    func calculateCircularDistance(from currentIndex: Int, to targetIndex: Int) -> Int {
        let itemCount = dataSource.count
        let directDistance = targetIndex - currentIndex
        let leftWrapDistance = targetIndex - currentIndex + itemCount
        let rightWrapDistance = targetIndex - currentIndex - itemCount
        let allDistances = [directDistance, leftWrapDistance, rightWrapDistance]
        return allDistances.min(by: { abs($0) < abs($1) }) ?? directDistance
    }
    
    func shouldDisableDrag(_ value: DragGesture.Value) -> Bool {
        guard !carousel.isInfiniteLoop else {
            return false
        }
        let itemCount = dataSource.count
        guard itemCount > 1 else {
            return true
        }
        return (selectedIndex == 0 && value.isScrollToRight) || (selectedIndex == itemCount - 1 && value.isScrollToLeft)
    }
    
    func autoPlayToNextItem() {
        guard let autoPlay = carousel.autoPlay,
              !dataSource.isEmpty else {
            return
        }
        
        let itemCount = dataSource.count
        let isInfinite = carousel.isInfiniteLoop
        let currentID = carouselLocation
        
        switch (autoPlay.direction, isInfinite) {
        case (.forward, true):
            moveToNextPosition(currentID + 1)
        case (.forward, false):
            if currentID >= itemCount - 1 {
                autoPlayManager.stop()
            } else {
                moveToNextPosition(currentID + 1)
            }
        case (.backward, true):
            moveToNextPosition(currentID - 1)
        case (.backward, false):
            if currentID <= 0 {
                autoPlayManager.stop()
            } else {
                moveToNextPosition(currentID - 1)
            }
        }
    }
    
    func moveToNextPosition(_ nextID: Int) {
        withAnimation(.easeInOut(duration: 0.5)) {
            carouselLocation = nextID
        }
    }
}
