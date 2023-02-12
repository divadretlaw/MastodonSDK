import Foundation
import AppAuth

public enum MastodonClientError: Swift.Error {
    case oAuthCancelled
}

public class MastodonClient: Networker {
    internal let baseURL: URL
    internal let urlSession: URLSession
    
    /// oAuth
    var currentAuthorizationFlow: OIDExternalUserAgentSession?
    var oAuthContinuation: CheckedContinuation<OIDAuthState, Swift.Error>?
    
    public init(baseURL: URL, urlSession: URLSession = .shared) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
    
    public func getAuthenticated(token: String?) throws -> MastodonSession {
        guard let token = token else {
            throw MastodonClientError.oAuthCancelled
        }
        return MastodonSession(baseURL: baseURL, urlSession: urlSession, token: token)
    }
    
    deinit {
        oAuthContinuation?.resume(throwing: MastodonClientError.oAuthCancelled)
        currentAuthorizationFlow?.cancel()
    }
}

public class MastodonSession: Networker {
    internal let token: String
    internal let baseURL: URL
    internal let urlSession: URLSession
    
    public init(baseURL: URL, urlSession: URLSession, token: String) {
        self.token = token
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
    
    public func saveMarkers(_ markers: [Mastodon.Markers.Timeline: String]) async throws -> Markers {
        let request = try Self.request(
            for: baseURL,
            target: Mastodon.Markers.set(markers),
            withBearerToken: token
        )
        
        let (data, _) = try await urlSession.data(for: request)
        
        return try Self.jsonDecoder.decode(Markers.self, from: data)
    }
    
    public func readMarkers(_ markers: Set<Mastodon.Markers.Timeline>) async throws -> Markers {
        let request = try Self.request(
            for: baseURL,
            target: Mastodon.Markers.read(markers),
            withBearerToken: token
        )
        
        let (data, _) = try await urlSession.data(for: request)
        
        return try Self.jsonDecoder.decode(Markers.self, from: data)
    }
}
