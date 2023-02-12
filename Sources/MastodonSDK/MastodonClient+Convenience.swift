//
//  MastodonClient+Convenience.swift
//  MastodonSDK
//
//  Created by Marcus Kida on 02.11.22.
//

import Foundation
import AppAuth

public extension MastodonClient {
    func createApp(
        named name: String,
        redirectUri: String = "urn:ietf:wg:oauth:2.0:oob",
        scopes: [String],
        website: URL? = nil
    ) async throws -> App {
        let request = try Self.request(
            for: baseURL,
            target: Mastodon.Apps.register(
                clientName: name,
                redirectUris: redirectUri,
                scopes: scopes.joined(separator: " "),
                website: website?.absoluteString
            )
        )
        
        let (data, _) = try await urlSession.data(for: request)
        
        return try Self.jsonDecoder.decode(App.self, from: data)
    }
    
    @MainActor
    func authenticate(on viewController: UIViewController, app: App, scopes: [String]) async throws -> OIDAuthState {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.authenticate(on: viewController, app: app, scopes: scopes) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func authenticate(on viewController: UIViewController, app: App, scopes: [String], completion: @escaping (Swift.Result<OIDAuthState, Swift.Error>) -> Void) {
        let configuration = OIDServiceConfiguration(authorizationEndpoint: baseURL.appendingPathComponent("oauth/authorize"),
                                                    tokenEndpoint: baseURL.appendingPathComponent("oauth/token"))
        
        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: app.clientId,
                                              clientSecret: app.clientSecret,
                                              scopes: scopes,
                                              redirectURL: URL(string: app.redirectUri) ?? URL(staticString: "urn:ietf:wg:oauth:2.0:oob"),
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: nil)
        
        self.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: viewController) { authState, error in
            if let authState = authState {
                completion(.success(authState))
            } else {
                completion(.failure(error!))
            }
        }
    }
    
    func handleOAuthResponse(url: URL) {
        if let authorizationFlow = self.currentAuthorizationFlow, authorizationFlow.resumeExternalUserAgentFlow(with: url) {
            self.currentAuthorizationFlow = nil
        }
    }
}
