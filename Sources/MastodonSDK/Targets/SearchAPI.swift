import Foundation

extension Mastodon {
    enum Search {
        case search(query: String, type: SearchType?, Bool)
        case status(URL)
        case account(String)
    }
}


extension Mastodon.Search: TargetType {
    var api: ApiVersion { .v2 }
    private var apiPath: String { "/api/\(api.rawValue)/search" }

    var path: String {
        switch self {
        case .search:
            return "\(apiPath)"
        case .status:
            return "\(apiPath)"
        case .account:
            return "\(apiPath)"
        }
    }
    
    var method: Method {
        switch self {
        case .search:
            return .get
        case .status:
            return .get
        case .account:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem?]? {
        switch self {
        case .search(let query, let type, let resolveNonLocal):
            return [
                URLQueryItem("q", value: query),
                URLQueryItem("type", value: type?.rawValue),
                URLQueryItem("resolve", value: resolveNonLocal.description)
            ]
        case .status(let url):
            return [
                URLQueryItem("q", value: url.absoluteString),
                URLQueryItem("type", value: SearchType.status.rawValue),
                URLQueryItem("resolve", value: "true")
            ]
        case .account(let url):
            return [
                URLQueryItem("q", value: url),
                URLQueryItem("type", value: SearchType.accounts.rawValue),
                URLQueryItem("resolve", value: "true")
            ]
        }
    }
}
