//
//  ContentView.swift
//  CarouselExampleApp
//
//  Created by Lei on 2025/7/29.
//

import SwiftUI
import SwiftUICarouselView

struct ContentView: View {
    private let itemWidth: CGFloat = 300
    private let itemHeight: CGFloat = 200
    
    var body: some View {
        CarouselView(layout: LayoutConfiguration(itemWidth: itemWidth, itemHeight: itemHeight), dataSource: carousalItems)
            .scaleAnimation()
            .indicator()
            .frame(maxWidth: .infinity)
    }
}

// MARK: - Private Methods
private extension ContentView {
    var carousalItems: [CarouselItem] {
        return [CarouselItem(content: {
            createCard("Item 1")
        }), CarouselItem(content: {
            createCard("Item 2")
        }), CarouselItem(content: {
            createCard("Item 3")
        }), CarouselItem(content: {
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
    
    @ViewBuilder
    var normalView: some View {
        Text("")
    }
}

#Preview {
    ContentView()
}
