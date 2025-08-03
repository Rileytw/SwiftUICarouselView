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
        Card(content: "Card 1"),
        Card(content: "Card 2"),
        Card(content: "Card 3"),
        Card(content: "Card 4")
    ]
    
    var body: some View {
        CarouselView(cards, id: \.id, selectedIndex: $currentIndex, itemSpacing: 0) { card in
            createCard(card.content)
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
        .frame(maxWidth: 300, maxHeight: 200)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct Card: Identifiable {
    let id: UUID = UUID()
    let content: String
}

#Preview {
    ContentView()
}
