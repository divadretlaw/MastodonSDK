import Foundation

extension Mastodon {
    enum Mutes {
        case mutes
    }
}

extension Mastodon.Mutes: TargetType {
    private var apiPath: String { "/api/\(api.rawValue)/mutes" }

    var path: String {
        switch self {
        case .mutes:
            return "\(apiPath)"
        }
    }
    
    var method: Method {
        switch self {
        case .mutes:
            return .get
        }
    }
}
