<div align="center">
  <img width="128" height="128" src="/Resources/icon/icon.png" alt="AdaptiveDimensions Icon">
  <h1><b>AdaptiveDimensions</b></h1>
  <p>
    SwiftUI modifiers that adapt layout dimensions to system text size settings.
  </p>
</div>

<p align="center">
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-6.0+-F05138?logo=swift&logoColor=white" alt="Swift 6.0+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/iOS-14+-000000?logo=apple" alt="iOS 14+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/macOS-11+-000000?logo=apple" alt="macOS 11+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/tvOS-14+-000000?logo=apple" alt="tvOS 14+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/watchOS-7+-000000?logo=apple" alt="watchOS 7+"></a>
  <a href="https://developer.apple.com"><img src="https://img.shields.io/badge/visionOS-1+-000000?logo=apple" alt="visionOS 1+"></a>
</p>


## Overview

- **Scaled frames** - Fixed dimensions that grow with Dynamic Type
- **Scaled padding** - Uniform, edge-specific, or custom insets
- **Scaled spacing** - VStack/HStack with proportional gaps
- **Scaled corner radius** - Corners that stay proportional

![Comparison of fixed vs adaptive scaling](/Resources/examples/visualexample.png)


## Installation

```swift
dependencies: [
    .package(url: "https://github.com/aeastr/AdaptiveDimensions.git", from: "1.0.0")
]
```

```swift
import AdaptiveDimensions
```


## Usage

All modifiers require a text style to determine the scaling curve. Use `.body` for most UI elements.

### Scaled Frames

```swift
Circle()
    .fill(.blue)
    .scaledFrame(width: 44, height: 44, relativeTo: .body)

// With flexible constraints
Rectangle()
    .scaledFrame(
        minWidth: 100, idealWidth: 200, maxWidth: 300,
        minHeight: 60, maxHeight: 120,
        relativeTo: .body
    )
```

### Scaled Padding

```swift
// Uniform
Text("Content")
    .scaledPadding(16, relativeTo: .body)

// Edge-specific
Text("Content")
    .scaledPadding(.horizontal, 20, relativeTo: .body)

// Custom insets
Text("Content")
    .scaledPadding(ScaledEdgeInsets(
        top: 24, leading: 16, bottom: 16, trailing: 16,
        relativeTo: .body
    ))
```

### Scaled Spacing

```swift
ScaledVStack(spacing: 12, relativeTo: .body) {
    Text("First")
    Text("Second")
}

ScaledHStack(spacing: 8, relativeTo: .body) {
    Text("One")
    Text("Two")
}
```

### Scaled Corner Radius

```swift
Rectangle()
    .fill(.orange)
    .scaledCornerRadius(12, relativeTo: .body)
```

### Combined Example

```swift
VStack {
    Text("Scaled Card").font(.headline)
    Text("Maintains proportions across all text sizes").font(.body)
}
.scaledPadding(20, relativeTo: .body)
.scaledFrame(minWidth: 200, maxWidth: 400, relativeTo: .body)
.background(.blue.gradient)
.scaledCornerRadius(16, relativeTo: .body)
```


## Text Style Reference

| Style | Use Case |
|-------|----------|
| `.largeTitle` | Large, prominent layouts |
| `.title`, `.title2`, `.title3` | Section headers |
| `.headline` | Emphasized content |
| `.body` | Standard UI (default) |
| `.callout`, `.subheadline` | Secondary content |
| `.footnote`, `.caption`, `.caption2` | Small UI details |


## Contributing

Contributions welcome. Please submit changes with clear descriptions.


## License

MIT. See [LICENSE](LICENSE) for details.
