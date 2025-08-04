//
//  ContentView.swift
//  CarouselExampleApp
//
//  Created by Lei on 2025/7/29.
//

import SwiftUI
import SwiftUICarouselView

struct ContentView: View {
    @State private var currentIndex: Int = 0
    let cards: [Card] = [
        Card(title: "Card 1", content: "Content of card 1"),
        Card(title: "Card 2", content: "Content of card 2"),
        Card(title: "Card 3", content: "Content of card 3"),
        Card(title: "Card 4", content: "Content of card 4")
    ]
    
    var body: some View {
        CarouselView(cards, selectedIndex: $currentIndex, itemSpacing: 0) { card in
            createCard(card)
                .padding(.vertical, 4)
        }
        .scaleAnimation()
        .indicator()
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Private Methods
private extension ContentView {
    @ViewBuilder
    func createCard(_ card: Card) -> some View {
        VStack {
            Text(card.title)
                .font(.title2)
                .fontWeight(.medium)
            
            Rectangle()
                .fill(Color.blue.opacity(0.1))
                .frame(height: 100)
                .overlay(
                    Text(card.content)
                        .foregroundColor(.secondary)
                )
        }
        .frame(maxWidth: 300, maxHeight: 200)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct Card {
    let title: String
    let content: String
}

#Preview {
    ContentView()
}
