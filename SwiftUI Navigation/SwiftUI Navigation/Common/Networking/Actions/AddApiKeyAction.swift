//
//  AddApiKeyAction.swift
//  KISS Views
//

import Foundation
import NgNetworkModuleCore

/// A network module action adding API key to an outgoing request as a parameter.
public final class AddApiKeyNetworkModuleAction: NetworkModuleAction {
    private let authenticationTokenProvider: AuthenticationTokenProvider

    /// A default AddApiKeyNetworkModuleAction initializer.
    ///
    /// - Parameter authenticationTokenProvider: an authentication token / API key provider.
    public init(authenticationTokenProvider: AuthenticationTokenProvider) {
        self.authenticationTokenProvider = authenticationTokenProvider
    }

    /// - SeeAlso: NetworkModuleAction.performBeforeExecutingNetworkRequest(request:urlRequest:)
    public func performBeforeExecutingNetworkRequest(request: NetworkRequest?, urlRequest: inout URLRequest) {
        guard request?.requiresAuthenticationToken == true else {
            return
        }

        let apiKeyValue = authenticationTokenProvider.authenticationToken
        var components = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)
        var queryItems = components?.queryItems ?? []
        queryItems.append(.init(name: "api_key", value: apiKeyValue))
        components?.queryItems = queryItems
        urlRequest.url = components?.url
    }
}
