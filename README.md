# AdaptiveDimensions

SwiftUI modifiers that adapt layout dimensions to system text size settings.

<p>
  <img src="https://img.shields.io/badge/iOS-14%2B-blue.svg" alt="iOS 14+">
  <img src="https://img.shields.io/badge/macOS-11%2B-blue.svg" alt="macOS 11+">
  <img src="https://img.shields.io/badge/watchOS-7%2B-blue.svg" alt="watchOS 7+">
  <img src="https://img.shields.io/badge/tvOS-14%2B-blue.svg" alt="tvOS 14+">
  <img src="https://img.shields.io/badge/visionOS-1%2B-blue.svg" alt="visionOS 1+">
  <img src="https://img.shields.io/badge/Swift-6.0-orange.svg" alt="Swift 6.0">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT">
</p>

AdaptiveDimensions provides SwiftUI modifiers that adjust layout dimensions in response to system text size changes. Instead of fixed values that remain constant, these modifiers scale frames, padding, spacing, and corner radius proportionally as Dynamic Type settings change, keeping your layout proportions intact across all size configurations.

<div align="center">
  <img width="600" src="/Resources/visualexample.png" alt="Comparison of fixed vs. adaptive UI scaling across text sizes. Shows three panels: 1) Large text size with proportional avatar and text, 2) AX1 accessibility size where fixed frame avatar becomes tiny compared to larger text while scaled frame avatar maintains proper proportion, 3) AX2 accessibility size showing the same pattern - fixed frame stays small while scaled frame grows appropriately with the text size.">
</div>

## Installation

### Swift Package Manager

Via Xcode:
1. File → Add Package Dependencies
2. Enter the repository URL
3. Select your version and add to the target

Or add directly to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/aeastr/AdaptiveDimensions.git", from: "1.0.0")
]
```

## Usage

All modifiers require a text style to determine the scaling curve. Use the style that matches your content's visual weight—`.body` works well for most UI elements.

### Scaled Frames

Fixed dimensions that adapt to text size:

```swift
Circle()
    .fill(.blue)
    .scaledFrame(width: 44, height: 44, relativeTo: .body)

Rectangle()
    .scaledFrame(width: 200, relativeTo: .body)
```

Flexible constraints with min, ideal, and max values:

```swift
Rectangle()
    .fill(.green)
    .scaledFrame(
        minWidth: 100,
        idealWidth: 200,
        maxWidth: 300,
        minHeight: 60,
        maxHeight: 120,
        relativeTo: .body
    )
```

### Scaled Padding

Uniform padding around all edges:

```swift
Text("Content")
    .scaledPadding(16, relativeTo: .body)
```

Edge-specific padding:

```swift
Text("Content")
    .scaledPadding(.horizontal, 20, relativeTo: .body)
```

Custom edge insets:

```swift
Text("Content")
    .scaledPadding(ScaledEdgeInsets(
        top: 24,
        leading: 16,
        bottom: 16,
        trailing: 16,
        relativeTo: .body
    ))
```

### Scaled Spacing

For stacks where spacing should scale with text size:

```swift
ScaledVStack(spacing: 12, relativeTo: .body) {
    Text("First")
    Text("Second")
    Text("Third")
}
```

```swift
ScaledHStack(spacing: 8, relativeTo: .body) {
    Text("One")
    Text("Two")
    Text("Three")
}
```

### Scaled Corner Radius

```swift
Rectangle()
    .fill(.orange)
    .scaledCornerRadius(12, relativeTo: .body)
```

### Combined Modifiers

Modifiers work together naturally:

```swift
VStack {
    Text("Scaled Card").font(.headline)
    Text("This layout maintains proportions across all text sizes").font(.body)
}
.scaledPadding(20, relativeTo: .body)
.scaledFrame(minWidth: 200, maxWidth: 400, relativeTo: .body)
.background(.blue.gradient)
.scaledCornerRadius(16, relativeTo: .body)
```

## Text Style Reference

Choose a style that matches your layout's visual weight:

| Style | Use Case |
|-------|----------|
| `.largeTitle` | Large, prominent layouts |
| `.title`, `.title2`, `.title3` | Section headers |
| `.headline` | Emphasized content |
| `.body` | Standard UI (default) |
| `.callout` | Secondary content |
| `.subheadline`, `.footnote`, `.caption`, `.caption2` | Small UI details |

## API Reference

### View Modifiers

**Frames**
- `scaledFrame(width:height:alignment:relativeTo:)`
- `scaledFrame(minWidth:idealWidth:maxWidth:minHeight:idealHeight:maxHeight:relativeTo:alignment:)`

**Padding**
- `scaledPadding(_:relativeTo:)` – uniform
- `scaledPadding(_:_:relativeTo:)` – edge-specific
- `scaledPadding(_:)` – ScaledEdgeInsets

**Styling**
- `scaledCornerRadius(_:relativeTo:)`

### Layout Containers

- `ScaledVStack(alignment:spacing:relativeTo:content:)`
- `ScaledHStack(alignment:spacing:relativeTo:content:)`

### Utilities

- `ScaledEdgeInsets(top:leading:bottom:trailing:relativeTo:)`

## Requirements

- iOS 14.0+, macOS 11.0+, watchOS 7.0+, tvOS 14.0+, visionOS 1.0+
- Swift 6.0+
- Xcode 16.0+

## License

MIT. See LICENSE file for details.

## Contributing

Pull requests are welcome. Please submit changes with clear descriptions and test coverage.
