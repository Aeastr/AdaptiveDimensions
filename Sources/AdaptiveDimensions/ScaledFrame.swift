//
//  ScaledFrame.swift
//
//
//  Created by Aether on 10/07/2023.
//

import SwiftUI

/// A SwiftUI view that applies a frame with dimensions that automatically scale based on Dynamic Type settings.
///
/// `ScaledFrame` wraps content and applies fixed width and/or height constraints that adapt to the user's
/// Dynamic Type preferences, ensuring layouts remain proportional and accessible across different text size settings.
///
/// ## Usage
///
/// ```swift
/// Rectangle()
///     .fill(.blue)
///     .scaledFrame(width: 100, height: 80, relativeTo: .body)
/// ```
///
/// - Note: Use `ScaledFrameFlexible` when you need min/ideal/max constraints instead of fixed dimensions.
///
/// ## Topics
///
/// ### Creating a Scaled Frame
/// - ``init(width:height:alignment:content:)``
///
/// ### Instance Properties
/// - ``body``
private struct ScaledFrame<Content>: View where Content: View {
    @ScaledMetric private var width: CGFloat
    @ScaledMetric private var height: CGFloat
    private var alignment: Alignment
    private var content: () -> Content

    /// Creates a scaled frame with optional fixed width and height dimensions.
    ///
    /// The dimensions automatically scale based on the user's Dynamic Type settings, maintaining
    /// proportional layouts across different accessibility text sizes.
    ///
    /// - Parameters:
    ///   - width: The scaled width constraint. Pass `nil` to allow the content to determine its own width.
    ///   - height: The scaled height constraint. Pass `nil` to allow the content to determine its own height.
    ///   - alignment: The alignment of the content within the frame. Defaults to `.center`.
    ///   - content: A view builder that creates the content to be framed.
    public init(
        width: ScaledMetric<CGFloat>? = nil,
        height: ScaledMetric<CGFloat>? = nil,
        alignment: Alignment = .center,
        @ViewBuilder content: @escaping () -> Content
    ) {
        _width = width ?? ScaledMetric(wrappedValue: -1)
        _height = height ?? ScaledMetric(wrappedValue: -1)
        self.alignment = alignment
        self.content = content
    }

    public var body: some View {
        content().frame(
            width: width > 0 ? width : nil,
            height: height > 0 ? height : nil,
            alignment: alignment
        )
    }
}

/// A SwiftUI view that applies a flexible frame with minimum, ideal, and maximum constraints that scale with Dynamic Type.
///
/// `ScaledFrameFlexible` provides more granular control over layout constraints than `ScaledFrame`,
/// allowing you to specify minimum, ideal, and maximum dimensions that all adapt to the user's
/// Dynamic Type preferences.
///
/// ## Usage
///
/// ```swift
/// Rectangle()
///     .fill(.green)
///     .scaledFrame(
///         minWidth: 100,
///         idealWidth: 200,
///         maxWidth: 300,
///         minHeight: 60,
///         maxHeight: 120,
///         relativeTo: .body
///     )
/// ```
///
/// - Note: Use `ScaledFrame` when you only need fixed dimensions without flexible constraints.
///
/// ## Topics
///
/// ### Creating a Flexible Scaled Frame
/// - ``init(minWidth:idealWidth:maxWidth:minHeight:idealHeight:maxHeight:alignment:content:)``
///
/// ### Instance Properties
/// - ``body``
private struct ScaledFrameFlexible<Content>: View where Content: View {
    @ScaledMetric private var minWidth: CGFloat
    @ScaledMetric private var idealWidth: CGFloat
    @ScaledMetric private var maxWidth: CGFloat
    @ScaledMetric private var minHeight: CGFloat
    @ScaledMetric private var idealHeight: CGFloat
    @ScaledMetric private var maxHeight: CGFloat
    private var alignment: Alignment
    private var content: () -> Content

    /// Creates a flexible scaled frame with minimum, ideal, and maximum dimension constraints.
    ///
    /// All specified dimensions automatically scale based on the user's Dynamic Type settings,
    /// maintaining proportional and flexible layouts across different accessibility text sizes.
    ///
    /// - Parameters:
    ///   - minWidth: The minimum scaled width. Pass `nil` for no minimum constraint.
    ///   - idealWidth: The ideal scaled width. Pass `nil` for no ideal size preference.
    ///   - maxWidth: The maximum scaled width. Pass `nil` for no maximum constraint.
    ///   - minHeight: The minimum scaled height. Pass `nil` for no minimum constraint.
    ///   - idealHeight: The ideal scaled height. Pass `nil` for no ideal size preference.
    ///   - maxHeight: The maximum scaled height. Pass `nil` for no maximum constraint.
    ///   - alignment: The alignment of the content within the frame. Defaults to `.center`.
    ///   - content: A view builder that creates the content to be framed.
    public init(
        minWidth: ScaledMetric<CGFloat>? = nil,
        idealWidth: ScaledMetric<CGFloat>? = nil,
        maxWidth: ScaledMetric<CGFloat>? = nil,
        minHeight: ScaledMetric<CGFloat>? = nil,
        idealHeight: ScaledMetric<CGFloat>? = nil,
        maxHeight: ScaledMetric<CGFloat>? = nil,
        alignment: Alignment = .center,
        @ViewBuilder content: @escaping () -> Content
    ) {
        _minWidth = minWidth ?? ScaledMetric(wrappedValue: -1)
        _idealWidth = idealWidth ?? ScaledMetric(wrappedValue: -1)
        _maxWidth = maxWidth ?? ScaledMetric(wrappedValue: -1)
        _minHeight = minHeight ?? ScaledMetric(wrappedValue: -1)
        _idealHeight = idealHeight ?? ScaledMetric(wrappedValue: -1)
        _maxHeight = maxHeight ?? ScaledMetric(wrappedValue: -1)
        self.alignment = alignment
        self.content = content
    }

    public var body: some View {
        content().frame(
            minWidth: minWidth > 0 ? minWidth : nil,
            idealWidth: idealWidth > 0 ? idealWidth : nil,
            maxWidth: maxWidth > 0 ? maxWidth : nil,
            minHeight: minHeight > 0 ? minHeight : nil,
            idealHeight: idealHeight > 0 ? idealHeight : nil,
            maxHeight: maxHeight > 0 ? maxHeight : nil,
            alignment: alignment
        )
    }
}

public extension View {
    /// Positions this view within a frame with the specified fixed dimensions that scale with Dynamic Type.
    ///
    /// Use this modifier to apply a scaled frame to any view. The dimensions automatically adjust
    /// based on the user's Dynamic Type settings relative to the specified text style.
    ///
    /// - Parameters:
    ///   - width: A fixed width for the frame, in points. Pass `nil` to use the view's natural width.
    ///   - height: A fixed height for the frame, in points. Pass `nil` to use the view's natural height.
    ///   - alignment: The alignment of the view within the frame. Defaults to `.center`.
    ///   - textStyle: The text style to use as a reference for scaling. Common values include `.body`, `.title`, `.headline`, etc.
    ///
    /// - Returns: A view with a scaled frame applied.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Circle()
    ///     .fill(.blue)
    ///     .scaledFrame(width: 44, height: 44, relativeTo: .body)
    /// ```
    func scaledFrame(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        alignment: Alignment = .center,
        relativeTo textStyle: Font.TextStyle
    ) -> some View {
        ScaledFrame(
            width: width.flatMap { ScaledMetric(wrappedValue: $0, relativeTo: textStyle) },
            height: height.flatMap { ScaledMetric(wrappedValue: $0, relativeTo: textStyle) },
            alignment: alignment
        ) {
            self
        }
    }

    /// Positions this view within a flexible frame with minimum, ideal, and maximum constraints that scale with Dynamic Type.
    ///
    /// Use this modifier when you need more control over layout constraints than fixed dimensions provide.
    /// All specified dimensions automatically adjust based on the user's Dynamic Type settings relative
    /// to the specified text style.
    ///
    /// - Parameters:
    ///   - minWidth: The minimum width for the frame, in points. Pass `nil` for no minimum constraint.
    ///   - idealWidth: The ideal width for the frame, in points. Pass `nil` for no ideal size preference.
    ///   - maxWidth: The maximum width for the frame, in points. Pass `nil` for no maximum constraint.
    ///   - minHeight: The minimum height for the frame, in points. Pass `nil` for no minimum constraint.
    ///   - idealHeight: The ideal height for the frame, in points. Pass `nil` for no ideal size preference.
    ///   - maxHeight: The maximum height for the frame, in points. Pass `nil` for no maximum constraint.
    ///   - textStyle: The text style to use as a reference for scaling. Common values include `.body`, `.title`, `.headline`, etc.
    ///   - alignment: The alignment of the view within the frame. Defaults to `.center`.
    ///
    /// - Returns: A view with a flexible scaled frame applied.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Rectangle()
    ///     .fill(.green)
    ///     .scaledFrame(
    ///         minWidth: 100,
    ///         idealWidth: 200,
    ///         maxWidth: 300,
    ///         relativeTo: .body
    ///     )
    /// ```
    func scaledFrame(
        minWidth: CGFloat? = nil,
        idealWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        idealHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        relativeTo textStyle: Font.TextStyle,
        alignment: Alignment = .center
    ) -> some View {
        ScaledFrameFlexible(
            minWidth: minWidth.flatMap { ScaledMetric(wrappedValue: $0, relativeTo: textStyle) },
            idealWidth: idealWidth.flatMap { ScaledMetric(wrappedValue: $0, relativeTo: textStyle) },
            maxWidth: maxWidth.flatMap { ScaledMetric(wrappedValue: $0, relativeTo: textStyle) },
            minHeight: minHeight.flatMap { ScaledMetric(wrappedValue: $0, relativeTo: textStyle) },
            idealHeight: idealHeight.flatMap { ScaledMetric(wrappedValue: $0, relativeTo: textStyle) },
            maxHeight: maxHeight.flatMap { ScaledMetric(wrappedValue: $0, relativeTo: textStyle) },
            alignment: alignment
        ) {
            self
        }
    }
}


@available(iOS 16, macOS 14, watchOS 10, tvOS 16, visionOS 1, *)
#Preview {
    @ViewBuilder
    func ExampleCard<Content: View>(
        title: String,
        description: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
            content()
            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    return ScrollView {
        VStack(spacing: 20) {
            Text("ScaledFrame Examples")
                .font(.largeTitle.bold())
                .padding(.top)

            ExampleCard(
                title: "Fixed Width",
                description: "100pt width, scales with Dynamic Type"
            ) {
                Rectangle()
                    .fill(.blue.gradient)
                    .scaledFrame(width: 100, relativeTo: .body)
                    .frame(height: 50)
            }

            ExampleCard(
                title: "Fixed Width & Height",
                description: "150×100pt, scales together"
            ) {
                Rectangle()
                    .fill(.purple.gradient)
                    .scaledFrame(width: 150, height: 100, relativeTo: .body)
            }

            ExampleCard(
                title: "Flexible Frame (Min/Max)",
                description: "Constrains between 100-300pt width, 60-120pt height"
            ) {
                Rectangle()
                    .fill(.green.gradient)
                    .scaledFrame(
                        minWidth: 100,
                        maxWidth: 300,
                        minHeight: 60,
                        maxHeight: 120,
                        relativeTo: .body
                    )
            }

            ExampleCard(
                title: "Ideal Width with Constraints",
                description: "Prefers 200pt, but adapts between 80pt and full width"
            ) {
                Rectangle()
                    .fill(.orange.gradient)
                    .scaledFrame(
                        minWidth: 80,
                        idealWidth: 200,
                        maxWidth: .infinity,
                        relativeTo: .body
                    )
                    .frame(height: 50)
            }

            ExampleCard(
                title: "Height Only",
                description: "Scales height, full width"
            ) {
                Rectangle()
                    .fill(.pink.gradient)
                    .scaledFrame(height: 80, relativeTo: .body)
            }
            
            
        }
        
        .padding()
    }
    
    
}
