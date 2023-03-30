//
//  NetworkingFactory.swift
//  KISS Views
//

import ConcurrentNgNetworkModule
import Foundation
import NgNetworkModuleCore

/// A networking components factory.
enum NetworkingFactory {

    /// Creates default network client.
    ///
    /// - Returns: a network client.
    static func makeNetworkingModule() -> NetworkModule {
        let builder = DefaultRequestBuilder(baseURL: AppConfiguration.baseURL)
        let apiKeyAction = AddApiKeyNetworkModuleAction(authenticationTokenProvider: AppConfiguration.apiKey)
        return DefaultNetworkModule(requestBuilder: builder, actions: [apiKeyAction])
    }
}
