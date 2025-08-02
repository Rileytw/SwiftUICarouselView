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
    var indicator: Indicator
    
    var body: some View {
        indicatorView
            .indicatorBackground(indicator.background)
    }
}

// MARK: - Private Methods
private extension IndicatorView {
    @ViewBuilder
    var indicatorView: some View {
        HStack {
            ForEach(dataSource.indices, id: \.self) { index in
                indicatorItemView(isSelected: index == currentIndex)
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
