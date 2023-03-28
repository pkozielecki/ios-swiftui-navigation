//
//  SwiftUINavigationHelpers.swift
//  KISS Views
//

import SwiftUI

extension Binding {

    /// A wrapper turning a binding to an enum into a binding of bool.
    /// To be used to display alerts with `presenting:` API.
    ///
    /// - Returns: a binding of a bool value.
    func isPresent<Wrapped>() -> Binding<Bool>
        where Value == Wrapped? {
        .init(
            get: {
                wrappedValue != nil
            },
            set: { isPresented in
                if !isPresented {
                    wrappedValue = nil
                }
            }
        )
    }
}

extension View {

    /// A convenience initializer for an alert.
    ///
    /// - Parameters:
    ///   - data: a binding to data the alert is presenting. The data must conform to `AlertRoutePresentable` protocol.
    ///   - confirmationActionTitle: a confirmation action title. Defaults to `Confirm`.
    ///   - cancellationActionTitle: a cancellation action title. Defaults to `Cancel`.
    ///   - confirmationActionCallback: a confirmation action callback. Called when user taps on a `Confirm` button.
    ///   - cancellationActionCallback: a cancellation action callback. Called when user taps on a `Cancel` button.
    /// - Returns: an alert view.
    func alert<T>(
        presenting data: Binding<T?>,
        confirmationActionTitle: String = "Confirm",
        cancellationActionTitle: String = "Cancel",
        confirmationActionCallback: @escaping (_ alert: T) -> Void,
        cancellationActionCallback: ((_ alert: T) -> Void)? = nil
    ) -> some View where T: AlertRoutePresentable {
        let title = data.wrappedValue?.title ?? ""
        let message = data.wrappedValue?.message ?? ""
        return alert(
            Text(title),
            isPresented: data.isPresent(),
            presenting: data.wrappedValue,
            actions: { alert in
                Button(role: .destructive) {
                    confirmationActionCallback(alert)
                } label: {
                    Text(confirmationActionTitle)
                }
                Button(role: .cancel) {
                    cancellationActionCallback?(alert)
                } label: {
                    Text(cancellationActionTitle)
                }
            },
            message: { _ in
                Text(message)
            }
        )
    }
}
