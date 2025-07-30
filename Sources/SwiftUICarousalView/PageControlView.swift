//
//  PageControlView.swift
//  SwiftUICarousalView
//
//  Created by Lei on 2025/7/30.
//

import SwiftUI

struct PageControlView: View {
    @Binding var currentIndex: Int
    @Binding var dataSource: [CarousalItem]
    var pageControlItem: PageControlItem
    
    var body: some View {
        HStack {
            ForEach(dataSource.indices, id: \.self) { index in
                pageControlItemView(isSelected: index == currentIndex)
            }
        }
    }
}

// MARK: - Private Methods
private extension PageControlView {
    @ViewBuilder
    func pageControlItemView(isSelected: Bool) -> some View {
        switch pageControlItem {
        case .default(let normal, let selected):
            Circle()
                .fill(isSelected ? selected : normal)
                .frame(width: 8, height: 8)
        case .custom(let provider):
            isSelected ? provider.selected : provider.normal
        }
    }
}
