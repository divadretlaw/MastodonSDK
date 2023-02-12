import Foundation

extension Mastodon {
    public enum Trends {
        case tags
        case status
        case links
    }
}

extension Mastodon.Trends: TargetType {
    private var apiPath: String { "/api/\(api.rawValue)/trends" }
    
    var path: String {
        switch self {
        case .tags:
            return "\(apiPath)/tags"
        case .status:
            return "\(apiPath)/statuses"
        case .links:
            return "\(apiPath)/links"
        }
    }
}
