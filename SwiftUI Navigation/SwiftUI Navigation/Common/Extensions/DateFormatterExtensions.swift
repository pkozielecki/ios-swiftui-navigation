//
//  DateFormatterExtensions.swift
//  KISS Views
//

import Foundation

extension DateFormatter {

    /// A full date and time data formatter.
    static let fullDateFormatter: DateFormatter = {
        let formatter = makeDateFormatter(dateFormat: "yyyy-MM-dd HH:mm:ss")
        formatter.timeZone = .current
        return formatter
    }()

    /// A year, month and day date formatter.
    static let dayMonthYearFormatter: DateFormatter = {
        let formatter = makeDateFormatter(dateFormat: "yyyy-MM-dd")
        formatter.timeZone = .current
        return formatter
    }()
}

private extension DateFormatter {

    static func makeDateFormatter(dateFormat: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter
    }
}
