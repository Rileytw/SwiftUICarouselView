//
//  IndicatorView.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/7/30.
//

import SwiftUI

struct IndicatorView: View {
    @Binding var currentIndex: Int
    @Binding var dataSource: [CarouselItem]
    @Binding var containerSize: CGSize
    var indicator: Indicator
    @State private var size: CGSize = .zero
    
    var body: some View {
        Group {
            if isOverSize {
                scrollableIndicatorView
            } else {
                indicatorView
            }
        }
        .frame(maxWidth: maxWidth)
    }
}

// MARK: - Private Methods
private extension IndicatorView {
    var isOverSize: Bool {
        return size.width > containerSize.width
    }
    
    var maxWidth: CGFloat {
        let width = isOverSize ? containerSize.width : size.width
        return width - 2 * indicator.horizontalInset
    }
    
    @ViewBuilder
    var indicatorView: some View {
        indicatorItemsView
            .indicatorBackground(indicator.background)
            .measureSize($size)
    }
    
    @ViewBuilder
    var scrollableIndicatorView: some View {
        ScrollViewReader { value in
            ScrollView(.horizontal, showsIndicators: false) {
                indicatorItemsView
            }
            .indicatorBackground(indicator.background)
            .onChange(of: currentIndex) { index in
                withAnimation(.easeInOut(duration: 0.3)) {
                    value.scrollTo(index, anchor: .center)
                }
            }
        }
    }
    
    @ViewBuilder
    var indicatorItemsView: some View {
        HStack {
            ForEach(dataSource.indices, id: \.self) { index in
                indicatorItemView(isSelected: index == currentIndex)
                    .id(index)
            }
        }
    }
    
    @ViewBuilder
    func indicatorItemView(isSelected: Bool) -> some View {
        switch indicator.type {
        case .default(let normal, let selected):
            Circle()
                .fill(isSelected ? selected : normal)
                .frame(width: 8, height: 8)
        case .custom(let provider):
            isSelected ? provider.selected : provider.normal
        }
    }
}
