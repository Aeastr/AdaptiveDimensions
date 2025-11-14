//
//  ScaledEdgeInsets.swift
//
//
//  Created by Aether on 13/11/2025.
//

import SwiftUI

/// A set of edge insets that automatically scale based on Dynamic Type settings.
///
/// `ScaledEdgeInsets` allows you to define padding values for each edge (top, leading, bottom, trailing)
/// that adapt to the user's Dynamic Type preferences, ensuring consistent spacing across different
/// accessibility text sizes.
///
/// ## Usage
///
/// ```swift
/// Text("Content")
///     .scaledPadding(ScaledEdgeInsets(
///         top: 20,
///         leading: 16,
///         bottom: 20,
///         trailing: 16,
///         relativeTo: .body
///     ))
/// ```
///
/// ## Topics
///
/// ### Creating Scaled Edge Insets
/// - ``init(top:leading:bottom:trailing:relativeTo:)``
public struct ScaledEdgeInsets {
    let top: ScaledMetric<CGFloat>?
    let leading: ScaledMetric<CGFloat>?
    let bottom: ScaledMetric<CGFloat>?
    let trailing: ScaledMetric<CGFloat>?

    /// Creates scaled edge insets with individual values for each edge.
    ///
    /// All specified inset values automatically scale based on the user's Dynamic Type settings
    /// relative to the specified text style.
    ///
    /// - Parameters:
    ///   - top: The top edge inset, in points. Pass `nil` for no top inset.
    ///   - leading: The leading edge inset, in points. Pass `nil` for no leading inset.
    ///   - bottom: The bottom edge inset, in points. Pass `nil` for no bottom inset.
    ///   - trailing: The trailing edge inset, in points. Pass `nil` for no trailing inset.
    ///   - textStyle: The text style to use as a reference for scaling. Defaults to `.body`.
    public init(
        top: CGFloat? = nil,
        leading: CGFloat? = nil,
        bottom: CGFloat? = nil,
        trailing: CGFloat? = nil,
        relativeTo textStyle: Font.TextStyle = .body
    ) {
        self.top = top.map { ScaledMetric(wrappedValue: $0, relativeTo: textStyle) }
        self.leading = leading.map { ScaledMetric(wrappedValue: $0, relativeTo: textStyle) }
        self.bottom = bottom.map { ScaledMetric(wrappedValue: $0, relativeTo: textStyle) }
        self.trailing = trailing.map { ScaledMetric(wrappedValue: $0, relativeTo: textStyle) }
    }
}

internal struct ScaledEdgeInsetsModifier: ViewModifier {
    @ScaledMetric private var top: CGFloat
    @ScaledMetric private var leading: CGFloat
    @ScaledMetric private var bottom: CGFloat
    @ScaledMetric private var trailing: CGFloat

    init(insets: ScaledEdgeInsets) {
        _top = insets.top ?? ScaledMetric(wrappedValue: 0)
        _leading = insets.leading ?? ScaledMetric(wrappedValue: 0)
        _bottom = insets.bottom ?? ScaledMetric(wrappedValue: 0)
        _trailing = insets.trailing ?? ScaledMetric(wrappedValue: 0)
    }

    func body(content: Content) -> some View {
        content.padding(EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing))
    }
}

public extension View {
    /// Applies scaled padding to each edge using the specified edge insets.
    ///
    /// Use this modifier to apply different padding values to each edge that automatically
    /// adapt to the user's Dynamic Type settings.
    ///
    /// - Parameter insets: The scaled edge insets to apply.
    ///
    /// - Returns: A view with scaled padding applied to each edge.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Text("Content")
    ///     .scaledPadding(ScaledEdgeInsets(
    ///         top: 24,
    ///         leading: 16,
    ///         bottom: 16,
    ///         trailing: 16,
    ///         relativeTo: .body
    ///     ))
    /// ```
    func scaledPadding(_ insets: ScaledEdgeInsets) -> some View {
        modifier(ScaledEdgeInsetsModifier(insets: insets))
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
            Text("ScaledEdgeInsets")
                .font(.largeTitle.bold())
                .padding(.top)

            ExampleCard(
                title: "Asymmetric Padding",
                description: "Different padding on each edge"
            ) {
                Text("Custom Padding")
                    .frame(maxWidth: .infinity)
                    .background(.blue.gradient)
                    .foregroundStyle(.white)
                    .scaledPadding(ScaledEdgeInsets(
                        top: 30,
                        leading: 10,
                        bottom: 30,
                        trailing: 40,
                        relativeTo: .body
                    ))
                    .background(.blue.opacity(0.3))
            }

            ExampleCard(
                title: "Vertical Only",
                description: "Padding on top and bottom"
            ) {
                Text("Vertical Padding")
                    .frame(maxWidth: .infinity)
                    .background(.purple.gradient)
                    .foregroundStyle(.white)
                    .scaledPadding(ScaledEdgeInsets(
                        top: 20,
                        bottom: 20,
                        relativeTo: .body
                    ))
                    .background(.purple.opacity(0.3))
            }

            ExampleCard(
                title: "Horizontal Only",
                description: "Padding on leading and trailing"
            ) {
                Text("Horizontal Padding")
                    .frame(maxWidth: .infinity)
                    .background(.green.gradient)
                    .foregroundStyle(.white)
                    .scaledPadding(ScaledEdgeInsets(
                        leading: 40,
                        trailing: 40,
                        relativeTo: .body
                    ))
                    .background(.green.opacity(0.3))
            }

            ExampleCard(
                title: "Card Layout",
                description: "More padding on top, less on sides"
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Title")
                        .font(.headline)
                    Text("This card has more padding on top to create visual hierarchy.")
                        .font(.body)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.orange.gradient)
                .foregroundStyle(.white)
                .scaledPadding(ScaledEdgeInsets(
                    top: 24,
                    leading: 16,
                    bottom: 16,
                    trailing: 16,
                    relativeTo: .body
                ))
                .background(.orange.opacity(0.3))
            }
        }
        .padding()
    }
}
