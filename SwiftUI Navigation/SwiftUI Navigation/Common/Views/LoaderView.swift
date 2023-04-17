//
//  LoaderView.swift
//  KISS Views
//

import SwiftUI

extension LoaderView {

    /// A configuration data for Loader View.
    struct Configuration {

        /// A message to show while loading.
        let message: String

        /// A loader width.
        let width: Double

        /// A loader height.
        let height: Double

        /// A loader background color.
        let backgroundColor: Color

        /// A loader background corner radius.
        let cornerRadius: Double
    }
}

struct LoaderView: View {
    let configuration: Configuration

    var body: some View {
        ZStack(alignment: .center) {
            ProgressView(configuration.message)
                .tint(.primary)
                .scaleEffect(2)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .frame(width: configuration.width, height: configuration.height)
        .background(configuration.backgroundColor)
        .cornerRadius(configuration.cornerRadius)
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView(configuration: .default)
    }
}

extension LoaderView.Configuration {

    /// A default Loader View configuration.
    static var `default`: LoaderView.Configuration {
        .init(
            message: "Loading...",
            width: 200,
            height: 150,
            backgroundColor: .secondary.opacity(0.2),
            cornerRadius: 10
        )
    }

    /// A Loader View configuration to be used for loading chart data.
    static var chartLoader: LoaderView.Configuration {
        .init(
            message: "Loading...",
            width: 800,
            height: 150,
            backgroundColor: .clear,
            cornerRadius: 0
        )
    }
}
