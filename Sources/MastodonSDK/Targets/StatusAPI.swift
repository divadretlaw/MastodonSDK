import Foundation

extension Mastodon {
    public enum Status {
        public enum Visibility: String, Codable {
            case direct = "direct"
            case `private` = "private"
            case unlisted = "unlisted"
            case `public` = "public"
        }
        case status(String)
        case statusHistory(String)
        case context(String)
        case card(String)
        case rebloggedBy(String)
        case favouritedBy(String)
        case new(Components)
        case delete(String)
        case reblog(String)
        case unreblog(String)
        case favourite(String)
        case unfavourite(String)
        case bookmark(String)
        case unbookmark(String)
    }
}

extension Mastodon.Status {
    public struct Components: Codable {
        let status: String
        let inReplyToId: String?
        let mediaIds: [String]?
        let sensitive: Bool
        let spoilerText: String?
        let visibility: Visibility
        
        public init(
            status: String,
            inReplyToId: String? = nil,
            mediaIds: [String]? = nil,
            sensitive: Bool,
            spoilerText: String? = nil,
            visibility: Visibility
        ) {
            self.status = status
            self.inReplyToId = inReplyToId
            self.mediaIds = mediaIds
            self.sensitive = sensitive
            self.spoilerText = spoilerText
            self.visibility = visibility
        }
    }
}

extension Mastodon.Status: TargetType {
    private var apiPath: String { "/api/\(api.rawValue)/statuses" }
    
    var path: String {
        switch self {
        case .status(let id):
            return "\(apiPath)/\(id)"
        case .statusHistory(let id):
            return "\(apiPath)/\(id)/history"
        case .context(let id):
            return "\(apiPath)/\(id)/context"
        case .card(let id):
            return "\(apiPath)/\(id)/card"
        case .rebloggedBy(let id):
            return "\(apiPath)/\(id)/reblogged_by"
        case .favouritedBy(let id):
            return "\(apiPath)/\(id)/favourited_by"
        case .new:
            return "\(apiPath)"
        case .delete(let id):
            return "\(apiPath)/\(id)"
        case .reblog(let id):
            return "\(apiPath)/\(id)/reblog"
        case .unreblog(let id):
            return "\(apiPath)/\(id)/unreblog"
        case .favourite(let id):
            return "\(apiPath)/\(id)/favourite"
        case .unfavourite(let id):
            return "\(apiPath)/\(id)/unfavourite"
        case .bookmark(let id):
            return "\(apiPath)/\(id)/bookmark"
        case .unbookmark(let id):
            return "\(apiPath)/\(id)/unbookmark"
        }
    }
    
    var method: Method {
        switch self {
        case .new,
             .reblog,
             .unreblog,
             .favourite,
             .unfavourite,
             .bookmark,
             .unbookmark:
            return .post
        case .delete:
            return .delete
        default:
            return .get
        }
    }
    
    var httpBody: Data? {
        switch self {
        case .new(let components):
            return try? MastodonClient.jsonEncoder.encode(components)
        default:
            return nil
        }
    }
}
