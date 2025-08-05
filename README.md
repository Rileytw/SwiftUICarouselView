# SwiftUICarouselView

A modern, customizable carousel view for SwiftUI with automatic sizing and native API design.

[![Swift](https://img.shields.io/badge/Swift-5.5+-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-14.0+-blue.svg)](https://developer.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-2.0+-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![SPM](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)](https://swift.org/package-manager/)


![Simulator Screen Recording - iPhone 16 Pro - 2025-08-04 at 15 52 51](https://github.com/user-attachments/assets/81076351-776e-4bfa-92fd-c35616ba8896)

![Simulator Screen Recording - iPhone 16 Pro - 2025-08-04 at 15 55 00](https://github.com/user-attachments/assets/e9dbcd46-b915-4d47-9e81-75c0adc578b2)

## Features

- **Automatic Content Sizing** - No manual height calculations needed
- **Generic Data Support** - Works with any `RandomAccessCollection`
- **Native SwiftUI API** - Feels like a built-in SwiftUI component
- **Smooth Animations** - Built-in scale effects and transitions
- **Customizable Indicators** - Default and custom indicator styles
- **Gesture Navigation** - Smooth drag-to-navigate with boundary protection

## Requirements

- iOS 14.0+
- Swift 5.5+
- Xcode 15.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/Rileytw/SwiftUICarouselView.git", from: "0.1.0")
]
```

## Quick Start

### Basic Usage

```swift
import SwiftUICarouselView

struct ContentView: View {
    @State private var selectedIndex = 0
    
    let photos = [
        Photo(name: "photo 1"),
        Photo(name: "photo 2"),
        Photo(name: "photo 3")
    ]
    
    var body: some View {
        CarouselView(photos, selectedIndex: $selectedIndex) { photo in
            PhotoView(photo)
                .frame(width: 300, height: 200)
        }
        .indicator()
        .scaleAnimation()
    }
}
```

### Advanced Customization

```swift
CarouselView(
    products,
    selectedIndex: $selectedIndex,
    itemSpacing: 24
) { product in
    ProductCardView(product: product)
        .frame(width: 280)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 8)
}
.indicator(.gray.opacity(0.4), .blue, topPadding: 20)
.scaleAnimation()
```

## Documentation

### Initializers
```swift
// Simple initializer - works with any RandomAccessCollection
CarouselView(
    _ data: Data,
    selectedIndex: Binding<Int>,
    itemSpacing: CGFloat = 16,
    @ViewBuilder content: @escaping (Data.Element) -> Content
)
```

### Modifiers

#### Indicators
```swift
// Default circular indicators
.indicator()

// Custom colors
.indicator(.gray, .blue, topPadding: 16)

// Custom views
.indicator(
    normal: Circle().fill(.gray).frame(width: 6, height: 6),
    selected: Circle().fill(.blue).frame(width: 10, height: 10)
)
```

#### Animations
```swift
// Default scale animation
.scaleAnimation()

// Custom scale animation
.scaleAnimation(ScaleAnimation(unselectedScale: 0.8, animation: .easeInOut))
```

## Usage Examples

### Working with Different Data Types

```swift
// With custom objects
let cards = [
    Card(title: "Card 1", content: "Content 1"),
    Card(title: "Card 2", content: "Content 2"),
    Card(title: "Card 3", content: "Content 3")
]

CarouselView(cards, selectedIndex: $selectedIndex) { card in
    CardView(card)
}

// With basic types
let colors: [Color] = [.red, .blue, .green, .orange]

CarouselView(colors, selectedIndex: $selectedIndex) { color in
    Circle()
        .fill(color)
        .frame(width: 100, height: 100)
}

// With arrays
let numbers = Array(1...10)

CarouselView(numbers, selectedIndex: $selectedIndex) { number in
    Text("\(number)")
        .font(.largeTitle)
        .frame(width: 80, height: 80)
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(Circle())
}
```

## Customization

### Custom Indicators

Create your own indicator styles:

```swift
.indicator(
    normal: {
        RoundedRectangle(cornerRadius: 4)
            .fill(.gray)
            .frame(width: 8, height: 4)
    },
    selected: {
        RoundedRectangle(cornerRadius: 4)
            .fill(.blue)
            .frame(width: 16, height: 4)
    }
)
```

### Animation Effects

Customize the scale animation:

```swift
.scaleAnimation(ScaleAnimation(
    unselectedScale: 0.85,
    animation: .spring(response: 0.6, dampingFraction: 0.8)
))
```

### Custom Spacing

Control the spacing between carousel items:

```swift
CarouselView(items, selectedIndex: $selectedIndex, itemSpacing: 32) { item in
    CustomItemView(item: item)
}
```

## How It Works

- **Automatic Sizing**: The carousel measures the first item's size to determine the optimal height


- **Progressive Enhancement**: Automatically uses the best implementation for each iOS version
  - **iOS 17+**: Native ScrollView with lazy loading and smooth scroll physics
  - **iOS 14-16**: Custom HStack implementation with drag gesture navigation  
    *(⚠️ Performance Note: iOS 14-16 loads all items in memory simultaneously. Debug builds will show warnings for larger datasets.)*

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
