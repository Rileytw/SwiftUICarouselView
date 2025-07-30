//
//  CarousalItem.swift
//  SwiftUICarousalView
//
//  Created by Lei on 2025/7/29.
//

import SwiftUI

public struct CarousalItem: Identifiable {
    public let id = UUID()
    public let view: AnyView
    
    public init<V: View>(@ViewBuilder content: () -> V) {
        self.view = AnyView(content())
    }
}
