import Foundation

extension Mastodon {
    enum Follows {
        case follow(String)
    }
}

extension Mastodon.Follows: TargetType {
    private var apiPath: String { "/api/\(api.rawValue)/follows" }
    
    var path: String {
        switch self {
        case .follow(_):
            return "\(apiPath)"
        }
    }
    
    var method: Method {
        switch self {
        case .follow:
            return .get
        }
    }
    
    var httpBody: Data? {
        switch self {
        case .follow(let uri):
            return try? MastodonClient.jsonEncoder.encode(
                ["uri": uri]
            )
        }
    }
}
