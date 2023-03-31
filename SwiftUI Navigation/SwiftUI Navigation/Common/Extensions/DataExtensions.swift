//
//  DataExtensions.swift
//  KISS Views
//

import Foundation

extension Data {

    /// Attempts to decode a encoded object to a provided type.
    ///
    /// - Parameter type: a type to decode data into.
    /// - Returns: a decoded object.
    func decoded<T: Decodable>(into type: T.Type) -> T? {
        try? JSONDecoder().decode(type, from: self)
    }
}
