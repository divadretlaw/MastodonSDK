import Foundation

extension Mastodon {
    enum Favourites {
        case favourites
    }
}

extension Mastodon.Favourites: TargetType {
    private var apiPath: String { "/api/\(api.rawValue)/favourites" }

    var path: String {
        switch self {
        case .favourites:
            return "\(apiPath)"
        }
    }
    
    var method: Method {
        switch self {
        case .favourites:
            return .get
        }
    }
}
