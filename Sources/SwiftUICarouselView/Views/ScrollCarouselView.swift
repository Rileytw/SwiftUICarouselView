//
//  ScrollCarouselView.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/8/5.
//

import SwiftUI

@available(iOS 17.0, *)
struct ScrollCarouselView<Data, Content>: View where Data: RandomAccessCollection, Content: View {
    @Environment(\.carousel) private var carousel
    @EnvironmentObject var autoPlayManager: CarouselAutoPlayManager
    
    @Binding var selectedIndex: Int
    @Binding var dataSource: Data
    @Binding var itemSize: CGSize
    @Binding var adjustedItemSpacing: CGFloat
    let content: (Data.Element) -> Content
    @State private var centeredViewID: Int?
    @State private var dataSourceArray: [Data] = []
    
    var body: some View {
        GeometryReader {  geometry in
            let itemWidth = itemSize.width
            let horizontalMargin = (geometry.size.width - itemWidth) / 2
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: adjustedItemSpacing) {
                    ForEach(items, id: \.offset) { index, element in
                        content(element)
                            .frame(width: itemSize.width)
                            .applyScaleAnimation(carousel.scaleAnimation, isSelected: index == (centeredViewID ?? 0 % dataSource.count), animationValue: selectedIndex)
                            .id(index)
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(.horizontal, horizontalMargin)
            .scrollPosition(id: $centeredViewID, anchor: .center)
            .scrollTargetBehavior(.viewAligned)
            .onChange(of: centeredViewID) { _, newValue in
                guard let newIndex = newValue else {
                    return
                }
                updateDataSourceArray()
                selectedIndex = newIndex % dataSource.count
            }
            .onReceive(autoPlayManager.$shouldMoveNext) { shouldMoveNext in
                if shouldMoveNext {
                    autoPlayToNextItem()
                }
            }
            .onAppear {
                centeredViewID = selectedIndex
                
                if carousel.isInfiniteLoop {
                    dataSourceArray = [dataSource, dataSource, dataSource]
                    
                    // Delay initial scroll position setup to prevent carousel offset
                    // Add 0.1s delay when setting initial centeredViewID to allow ScrollView layout calculations to complete, preventing visual offset on appear.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        centeredViewID = dataSource.count + selectedIndex
                    }
                }
                
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
}

// MARK: - Private Methods
@available(iOS 17.0, *)
private extension ScrollCarouselView {
    var items: [EnumeratedSequence<Data>.Element] {
       return carousel.isInfiniteLoop ? Array(dataSourceArray.flatMap { $0 }.enumerated()) : Array(dataSource.enumerated())
    }
    
    func updateDataSourceArray() {
        guard carousel.isInfiniteLoop,
              let centeredViewID = centeredViewID else {
            return
        }
        
        let itemCount = dataSource.count
        let currentSegments = dataSourceArray.count
        let rightTrigger = (currentSegments - 1) * itemCount
        let leftTrigger = itemCount - 1
        
        // TODO: Update animation
        if centeredViewID >= rightTrigger  {
            var transaction = Transaction()
            transaction.disablesAnimations = true
            
            withTransaction(transaction) {
                dataSourceArray.append(dataSource)
                dataSourceArray.removeFirst()
                self.centeredViewID = centeredViewID - itemCount
            }
        } else if centeredViewID <= leftTrigger {
            var transaction = Transaction()
            transaction.disablesAnimations = true
            
            withTransaction(transaction) {
                dataSourceArray.insert(dataSource, at: 0)
                dataSourceArray.removeLast()
                self.centeredViewID = centeredViewID + itemCount
            }
        }
    }
    
    func autoPlayToNextItem() {
        guard let autoPlay = carousel.autoPlay,
              let currentID = centeredViewID,
              !dataSource.isEmpty else {
            return
        }
        
        let itemCount = dataSource.count
        let isInfinite = carousel.isInfiniteLoop
        
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
            centeredViewID = nextID
        }
    }
}
