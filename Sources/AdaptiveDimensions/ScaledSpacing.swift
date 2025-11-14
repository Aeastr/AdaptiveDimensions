//
//  ScaledSpacing.swift
//
//
//  Created by Aether on 13/11/2025.
//

import SwiftUI

// MARK: - Scaled VStack

/// A vertical stack that arranges views with spacing that automatically scales based on Dynamic Type settings.
///
/// `ScaledVStack` works like SwiftUI's `VStack`, but the spacing between views adapts to the user's
/// Dynamic Type preferences, ensuring proportional layouts across different accessibility text sizes.
///
/// ## Usage
///
/// ```swift
/// ScaledVStack(spacing: 12, relativeTo: .body) {
///     Text("First")
///     Text("Second")
///     Text("Third")
/// }
/// ```
///
/// ## Topics
///
/// ### Creating a Scaled VStack
/// - ``init(alignment:spacing:relativeTo:content:)``
///
/// ### Instance Properties
/// - ``body``
public struct ScaledVStack<Content: View>: View {
    @ScaledMetric private var spacing: CGFloat
    private let alignment: HorizontalAlignment
    private let content: Content

    /// Creates a vertical stack with scaled spacing between child views.
    ///
    /// The spacing value automatically scales based on the user's Dynamic Type settings
    /// relative to the specified text style.
    ///
    /// - Parameters:
    ///   - alignment: The horizontal alignment of views within the stack. Defaults to `.center`.
    ///   - spacing: The vertical spacing between views, in points.
    ///   - textStyle: The text style to use as a reference for scaling. Defaults to `.body`.
    ///   - content: A view builder that creates the child views.
    public init(
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat,
        relativeTo textStyle: Font.TextStyle = .body,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        _spacing = ScaledMetric(wrappedValue: spacing, relativeTo: textStyle)
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            content
        }
    }
}

// MARK: - Scaled HStack

/// A horizontal stack that arranges views with spacing that automatically scales based on Dynamic Type settings.
///
/// `ScaledHStack` works like SwiftUI's `HStack`, but the spacing between views adapts to the user's
/// Dynamic Type preferences, ensuring proportional layouts across different accessibility text sizes.
///
/// ## Usage
///
/// ```swift
/// ScaledHStack(spacing: 8, relativeTo: .body) {
///     Text("First")
///     Text("Second")
///     Text("Third")
/// }
/// ```
///
/// ## Topics
///
/// ### Creating a Scaled HStack
/// - ``init(alignment:spacing:relativeTo:content:)``
///
/// ### Instance Properties
/// - ``body``
public struct ScaledHStack<Content: View>: View {
    @ScaledMetric private var spacing: CGFloat
    private let alignment: VerticalAlignment
    private let content: Content

    /// Creates a horizontal stack with scaled spacing between child views.
    ///
    /// The spacing value automatically scales based on the user's Dynamic Type settings
    /// relative to the specified text style.
    ///
    /// - Parameters:
    ///   - alignment: The vertical alignment of views within the stack. Defaults to `.center`.
    ///   - spacing: The horizontal spacing between views, in points.
    ///   - textStyle: The text style to use as a reference for scaling. Defaults to `.body`.
    ///   - content: A view builder that creates the child views.
    public init(
        alignment: VerticalAlignment = .center,
        spacing: CGFloat,
        relativeTo textStyle: Font.TextStyle = .body,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        _spacing = ScaledMetric(wrappedValue: spacing, relativeTo: textStyle)
        self.content = content()
    }

    public var body: some View {
        HStack(alignment: alignment, spacing: spacing) {
            content
        }
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
            Text("Scaled Spacing")
                .font(.largeTitle.bold())
                .padding(.top)

            ExampleCard(
                title: "ScaledVStack",
                description: "Vertical spacing that adapts to Dynamic Type"
            ) {
                ScaledVStack(spacing: 12, relativeTo: .body) {
                    ForEach(1...5, id: \.self) { i in
                        Text("Item \(i)")
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(.blue.gradient)
                            .foregroundStyle(.white)
                            .cornerRadius(8)
                    }
                }
            }

            ExampleCard(
                title: "ScaledHStack",
                description: "Horizontal spacing that adapts to Dynamic Type"
            ) {
                ScaledHStack(spacing: 12, relativeTo: .body) {
                    ForEach(1...3, id: \.self) { i in
                        Text("\(i)")
                            .padding(12)
                            .background(.purple.gradient)
                            .foregroundStyle(.white)
                            .cornerRadius(8)
                    }
                }
            }

            ExampleCard(
                title: "Different Text Styles",
                description: "Spacing relative to .body vs .title"
            ) {
                VStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("Body spacing (12pt)")
                            .font(.caption)
                        ScaledVStack(spacing: 12, relativeTo: .body) {
                            ForEach(1...3, id: \.self) { i in
                                Text("Item \(i)")
                                    .padding(6)
                                    .frame(maxWidth: .infinity)
                                    .background(.green.gradient)
                                    .foregroundStyle(.white)
                                    .cornerRadius(6)
                            }
                        }
                    }

                    VStack(alignment: .leading) {
                        Text("Title spacing (12pt)")
                            .font(.caption)
                        ScaledVStack(spacing: 12, relativeTo: .title) {
                            ForEach(1...3, id: \.self) { i in
                                Text("Item \(i)")
                                    .padding(6)
                                    .frame(maxWidth: .infinity)
                                    .background(.orange.gradient)
                                    .foregroundStyle(.white)
                                    .cornerRadius(6)
                            }
                        }
                    }
                }
            }

            ExampleCard(
                title: "Nested Stacks",
                description: "Combining scaled vertical and horizontal spacing"
            ) {
                ScaledVStack(spacing: 16, relativeTo: .body) {
                    ForEach(1...3, id: \.self) { row in
                        ScaledHStack(spacing: 8, relativeTo: .body) {
                            ForEach(1...3, id: \.self) { col in
                                Text("\(row),\(col)")
                                    .padding(8)
                                    .background(.pink.gradient)
                                    .foregroundStyle(.white)
                                    .cornerRadius(6)
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}
