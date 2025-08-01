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
    var indicatorStyle: IndicatorStyle
    
    var body: some View {
        HStack {
            ForEach(dataSource.indices, id: \.self) { index in
                indicatorView(isSelected: index == currentIndex)
            }
        }
        .indicatorBackground(backgroundStyle)
    }
}

// MARK: - Private Methods
private extension IndicatorView {
    var backgroundStyle: IndicatorBackgroundStyle? {
        switch indicatorStyle {
        case .default(_, _, let background):
            return background
        case .custom(_, let background):
            return background
        }
    }
    
    @ViewBuilder
    func indicatorView(isSelected: Bool) -> some View {
        switch indicatorStyle {
        case .default(let normal, let selected, _):
            Circle()
                .fill(isSelected ? selected : normal)
                .frame(width: 8, height: 8)
        case .custom(let provider, _):
            isSelected ? provider.selected : provider.normal
        }
    }
}
