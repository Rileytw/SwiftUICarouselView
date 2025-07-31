//
//  CarousalView.swift
//  SwiftUICarousalView
//
//  Created by Lei on 2025/7/29.
//

import SwiftUI

public struct CarousalView: View {
    @Environment(\.indicatorStyle) private var indicatorStyle
    
    @State private var configuration: CarousalConfiguration
    @State private var dataSource: [CarousalItem]
    @State private var currentIndex: Int = 0
    @State private var offset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    
    public init(configuration: CarousalConfiguration, dataSource: [CarousalItem]) {
        self.configuration = configuration
        self.dataSource = dataSource
    }
    
    public var body: some View {
        VStack(spacing: configuration.verticalPadding) {
            carousalView
                .frame(maxWidth: .infinity, maxHeight: configuration.itemHeight)
            
            if let indicatorStyle = indicatorStyle {
                IndicatorView(currentIndex: $currentIndex, dataSource: $dataSource, indicatorStyle: indicatorStyle)
            }
        }
        .background(configuration.backgroundColor)
        .padding()
        .clipped()
    }
}

// MARK: - Public Methods
public extension CarousalView {
    func indicatorEnabled(_ normalColor: Color = .gray, _ selectedColor: Color = .blue, backgroundStyle: IndicatorBackgroundStyle? = nil) -> some View {
        self.environment(\.indicatorStyle, .default(normalColor, selectedColor, backgroundStyle))
    }
    
    func indicatorEnabled<N: View, S: View>(normal: N, selected: S, backgroundStyle: IndicatorBackgroundStyle? = nil) -> some View {
        self.environment(\.indicatorStyle, .custom(IndicatorCustomViews(normal: normal, selected: selected), backgroundStyle))
    }
    
    func indicatorEnabled<N: View, S: View>(@ViewBuilder normal: () -> N, @ViewBuilder selected: () -> S, backgroundStyle: IndicatorBackgroundStyle? = nil) -> some View {
        self.environment(\.indicatorStyle, .custom(IndicatorCustomViews(normal: normal, selected: selected), backgroundStyle))
    }
}

// MARK: - Private Methods
private extension CarousalView {
    @ViewBuilder
    var carousalView: some View {
        GeometryReader { geometry in
            let itemWidth = configuration.itemWidth
            
            HStack(spacing: configuration.itemPadding) {
                ForEach(dataSource) { item in
                    item.view
                        .frame(width: itemWidth)
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
                        
                        handleDragEnd(value, itemWidth: itemWidth, spacing: configuration.itemPadding, parentViewWidth: geometry.size.width)
                    }
            )
            .onAppear {
                offset = -(itemWidth + configuration.itemPadding) * CGFloat(currentIndex) + (geometry.size.width - itemWidth) / 2
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
