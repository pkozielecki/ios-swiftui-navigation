//
//  TextStyles.swift
//  KISS Views
//

import SwiftUI

struct PrimaryButtonLabelModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .lineLimit(1)
            .font(.title3)
            .fontWeight(.bold)
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
    }
}

struct SecondaryButtonLabelModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .lineLimit(1)
            .underline()
            .font(.headline)
            .fontWeight(.medium)
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
    }
}

extension Text {

    func primaryButtonLabel() -> some View {
        modifier(PrimaryButtonLabelModifier())
    }

    func secondaryButtonLabel() -> some View {
        modifier(SecondaryButtonLabelModifier())
    }
}
