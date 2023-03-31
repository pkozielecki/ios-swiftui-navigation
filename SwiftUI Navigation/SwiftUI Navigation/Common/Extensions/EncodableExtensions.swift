//
//  EncodableExtensions.swift
//  KISS Views
//

import Foundation

extension Encodable {

    /// A helper encoding an Encodable type into data.
    var data: Data? {
        try? JSONEncoder().encode(self)
    }
}
