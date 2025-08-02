//
//  SizeCalculatorModifier.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/8/2.
//

import SwiftUI

struct SizeCalculatorModifier: ViewModifier {
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: SizePreferenceKey.self,
                                    value: geometry.size)
                }
            )
            .onPreferenceChange(SizePreferenceKey.self) { newSize in
                size = newSize
            }
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
