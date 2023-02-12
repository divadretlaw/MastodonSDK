import Foundation

extension Mastodon {
    enum Blocks {
        case blocks
    }
}

extension Mastodon.Blocks: TargetType {
    private var apiPath: String { "/api/\(api.rawValue)/blocks" }
    
    var path: String {
        switch self {
        case .blocks:
            return "\(apiPath)"
        }
    }
}
