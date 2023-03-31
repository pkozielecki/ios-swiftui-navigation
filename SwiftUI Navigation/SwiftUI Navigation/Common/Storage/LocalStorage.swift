//
//  LocalStorage.swift
//  KISS Views
//

import Foundation

/// An abstraction allowing to store & retrieve data from local storage.
protocol LocalStorage {

    /// Retrieves a data value stored under a provided key.
    ///
    /// - Parameter defaultName: key.
    /// - Returns: value.
    func data(forKey defaultName: String) -> Data?

    /// Sets a value under a provided key.
    ///
    /// - Parameters:
    ///   - value: value to store.
    ///   - defaultName: key.
    func set(_ value: Any?, forKey defaultName: String)

    /// Removed value stored under a provided key.
    ///
    /// - Parameter defaultName: key.
    func removeObject(forKey defaultName: String)

    /// Immediately synchronizes values storage.
    ///
    /// - Returns: synchronisation status.
    func synchronize() -> Bool
}

extension UserDefaults: LocalStorage {}
