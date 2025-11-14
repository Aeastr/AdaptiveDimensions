//
//  ScaledModifiers.swift
//
//
//  Created by Aether on 13/11/2025.
//

import SwiftUI

// MARK: - Scaled Padding

private struct ScaledPaddingModifier: ViewModifier {
    @ScaledMetric private var padding: CGFloat

    init(padding: CGFloat, relativeTo textStyle: Font.TextStyle) {
        _padding = ScaledMetric(wrappedValue: padding, relativeTo: textStyle)
    }

    func body(content: Content) -> some View {
        content.padding(padding)
    }
}

private struct ScaledEdgePaddingModifier: ViewModifier {
    @ScaledMetric private var padding: CGFloat
    let edges: Edge.Set

    init(edges: Edge.Set, padding: CGFloat, relativeTo textStyle: Font.TextStyle) {
        self.edges = edges
        _padding = ScaledMetric(wrappedValue: padding, relativeTo: textStyle)
    }

    func body(content: Content) -> some View {
        content.padding(edges, padding)
    }
}

public extension View {
    /// Applies scaled padding to all edges of the view.
    ///
    /// The padding value automatically scales based on the user's Dynamic Type settings
    /// relative to the specified text style.
    ///
    /// - Parameters:
    ///   - padding: The amount of padding to apply to all edges, in points.
    ///   - textStyle: The text style to use as a reference for scaling. Defaults to `.body`.
    ///
    /// - Returns: A view with scaled padding applied to all edges.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Text("Content")
    ///     .scaledPadding(16, relativeTo: .body)
    /// ```
    func scaledPadding(_ padding: CGFloat, relativeTo textStyle: Font.TextStyle = .body) -> some View {
        modifier(ScaledPaddingModifier(padding: padding, relativeTo: textStyle))
    }

    /// Applies scaled padding to specific edges of the view.
    ///
    /// The padding value automatically scales based on the user's Dynamic Type settings
    /// relative to the specified text style.
    ///
    /// - Parameters:
    ///   - edges: The edges to apply padding to. Defaults to `.all`.
    ///   - padding: The amount of padding to apply, in points.
    ///   - textStyle: The text style to use as a reference for scaling. Defaults to `.body`.
    ///
    /// - Returns: A view with scaled padding applied to the specified edges.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Text("Content")
    ///     .scaledPadding(.horizontal, 20, relativeTo: .body)
    /// ```
    func scaledPadding(_ edges: Edge.Set = .all, _ padding: CGFloat, relativeTo textStyle: Font.TextStyle = .body) -> some View {
        modifier(ScaledEdgePaddingModifier(edges: edges, padding: padding, relativeTo: textStyle))
    }
}

// MARK: - Scaled Corner Radius

private struct ScaledCornerRadiusModifier: ViewModifier {
    @ScaledMetric private var radius: CGFloat

    init(radius: CGFloat, relativeTo textStyle: Font.TextStyle) {
        _radius = ScaledMetric(wrappedValue: radius, relativeTo: textStyle)
    }

    func body(content: Content) -> some View {
        content.cornerRadius(radius)
    }
}

public extension View {
    /// Applies a scaled corner radius to the view.
    ///
    /// The corner radius value automatically scales based on the user's Dynamic Type settings
    /// relative to the specified text style, maintaining proportional rounded corners across
    /// different accessibility text sizes.
    ///
    /// - Parameters:
    ///   - radius: The corner radius to apply, in points.
    ///   - textStyle: The text style to use as a reference for scaling. Defaults to `.body`.
    ///
    /// - Returns: A view with scaled corner radius applied.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Rectangle()
    ///     .fill(.blue)
    ///     .scaledCornerRadius(12, relativeTo: .body)
    /// ```
    func scaledCornerRadius(_ radius: CGFloat, relativeTo textStyle: Font.TextStyle = .body) -> some View {
        modifier(ScaledCornerRadiusModifier(radius: radius, relativeTo: textStyle))
    }
}

// MARK: - Preview

@available(iOS 16, macOS 14, watchOS 10, tvOS 16, visionOS 1, *)
private struct ExampleCard<Content: View>: View {
    let title: String
    let description: String
    let content: Content

    init(
        title: String,
        description: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.description = description
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
            content
            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

@available(iOS 16, macOS 14, watchOS 10, tvOS 16, visionOS 1, *)
#Preview {
    ScrollView {
        VStack(spacing: 20) {
            Text("Scaled Modifiers")
                .font(.largeTitle.bold())
                .padding(.top)

            ExampleCard(
                title: "Scaled Padding",
                description: "Padding that adapts to Dynamic Type"
            ) {
                Text("Scaled Padding")
                    .scaledPadding(24, relativeTo: .body)
                    .background(.blue.gradient)
                    .foregroundStyle(.white)
            }

            ExampleCard(
                title: "Scaled Edge Padding",
                description: "Padding on specific edges"
            ) {
                Text("Leading Padding")
                    .scaledPadding(.leading, 40, relativeTo: .body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.purple.gradient)
                    .foregroundStyle(.white)
            }

            ExampleCard(
                title: "Scaled Corner Radius",
                description: "Corners that scale with text size"
            ) {
                Rectangle()
                    .fill(.green.gradient)
                    .frame(height: 100)
                    .scaledCornerRadius(20, relativeTo: .body)
            }

            ExampleCard(
                title: "Combined",
                description: "Padding and corner radius together"
            ) {
                Text("Scaled Card")
                    .scaledPadding(20, relativeTo: .body)
                    .background(.orange.gradient)
                    .foregroundStyle(.white)
                    .scaledCornerRadius(12, relativeTo: .body)
            }
        }
        .padding()
    }
}
