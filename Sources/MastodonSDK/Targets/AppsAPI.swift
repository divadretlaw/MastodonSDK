import Foundation

extension Mastodon {
    enum Apps {
        case register(clientName: String, redirectUris: String, scopes: String?, website: String?)
    }
}

extension Mastodon.Apps: TargetType {
    struct Request: Encodable {
        let clientName: String
        let redirectUris: String
        let scopes: String?
        let website: String?
    }
    
    private var apiPath: String { "/api/\(api.rawValue)/apps" }

    var path: String {
        switch self {
        case .register:
            return "\(apiPath)"
        }
    }
    
    var method: Method {
        switch self {
        case .register:
            return .post
        }
    }
    
    var httpBody: Data? {
        switch self {
        case .register(let clientName, let redirectUris, let scopes, let website):
            return try? MastodonClient.jsonEncoder.encode(
                Request(clientName: clientName, redirectUris: redirectUris, scopes: scopes, website: website)
            )
        }
    }
}
