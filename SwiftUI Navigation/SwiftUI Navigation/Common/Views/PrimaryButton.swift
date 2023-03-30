//
//  PrimaryButton.swift
//  KISS Views
//

import SwiftUI

struct PrimaryButton: View {
    let label: String
    let onTapCallback: (() async -> Void)?

    var body: some View {
        Button {
            Task {
                await onTapCallback?()
            }
        } label: {
            Text(label)
                .primaryButtonLabel()
                .frame(maxWidth: .infinity)
        }
        .primaryButton()
    }
}
