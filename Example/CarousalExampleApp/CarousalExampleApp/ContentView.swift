//
//  ContentView.swift
//  CarousalExampleApp
//
//  Created by Lei on 2025/7/29.
//

import SwiftUI
import SwiftUICarousalView

struct ContentView: View {
    private let itemWidth: CGFloat = 300
    private let itemHeight: CGFloat = 200
    
    var body: some View {
        CarousalView(configuration: CarousalConfiguration(itemWidth: itemWidth, itemHeight: itemHeight), dataSource: carousalItems)
//            .indicatorEnabled() // TODO: Fix environment key issues
            .scaleEffectEnabled()
            .frame(maxWidth: .infinity)
    }
}

// MARK: - Private Methods
private extension ContentView {
    var carousalItems: [CarousalItem] {
        return [CarousalItem(content: {
            createCard("Item 1")
        }), CarousalItem(content: {
            createCard("Item 2")
        }), CarousalItem(content: {
            createCard("Item 3")
        }), CarousalItem(content: {
            createCard("Item 4")
        })]
    }
    
    @ViewBuilder
    func createCard(_ content: String) -> some View {
        VStack {
            Text(content)
                .font(.title2)
                .fontWeight(.medium)
            
            Rectangle()
                .fill(Color.blue.opacity(0.1))
                .frame(height: 100)
                .overlay(
                    Text("Content")
                        .foregroundColor(.secondary)
                )
        }
        .frame(width: itemWidth, height: itemHeight)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

#Preview {
    ContentView()
}
