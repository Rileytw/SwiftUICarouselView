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
        HStack {
            ForEach(dataSource.indices, id: \.self) { index in
                indicatorView(isSelected: index == currentIndex)
            }
        }
        .indicatorBackground(indicator.background)
    }
}

// MARK: - Private Methods
private extension IndicatorView {
    @ViewBuilder
    func indicatorView(isSelected: Bool) -> some View {
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
