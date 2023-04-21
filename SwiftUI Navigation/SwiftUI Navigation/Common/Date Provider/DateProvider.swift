//
//  DateProvider.swift
//  KISS Views
//

import Foundation

/// An abstraction providing current date.
protocol DateProvider {

    /// Provides current date.
    ///
    /// - Returns: current date.
    func currentDate() -> Date
}

/// Default DateProvider implementation.
final class DefaultDateProvider: DateProvider {

    /// SeeAlso: DateProvider.currentDate()
    func currentDate() -> Date {
        Date()
    }
}
