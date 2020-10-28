//
//  ActivityIndicator.swift
//  Restaurants
//
//  Created by S on 10/27/20.
//

import Foundation
import UIKit
import SwiftUI

/// A View of a `UIActivityIndicatorView` allowing it to be used with SwiftUI
public struct ActivityIndicator {

    /// The visual style of the progress indicator.
    public typealias Style = UIActivityIndicatorView.Style

    private let style: Style
    private let color: UIColor
    private let isAnimating: Bool

    /// Creates an `ActivityIndicator` that is presented with the `UIActivityIndicatorViewStyleMedium` style.
    ///
    /// - parameters:
    ///     - style: The style to display the activity indicator.default is
    ///     `UIActivityIndicatorView.Style.medium`
    ///     - color: The color of the activity indicator. default is `gray`
    ///     - isAnimating: A Boolean value indicating whether the activity indicator is currently running its animation. default is `true`
    public init(
        style: Style = .medium,
        color: UIColor = .gray,
        isAnimating: Bool = true
    ) {
        self.style = style
        self.color = color
        self.isAnimating = isAnimating
    }
}

extension ActivityIndicator: UIViewRepresentable {

    public func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    public func updateUIView(_ activityIndicator: UIActivityIndicatorView, context: Context) {
        activityIndicator.style = style
        activityIndicator.color = color
        isAnimating ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}
