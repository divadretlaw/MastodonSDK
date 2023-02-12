import Foundation

extension Mastodon {
    enum Account {
        case account(String)
        case verifyCredentials
        case followers(String)
        case following(String)
        case status(parameters: StatusParameters)
        case follow(String)
        case unfollow(String)
        case block(String)
        case unblock(String)
        case mute(String)
        case unmute(String)
        case relationships([String])
        case search(String, Int)
        
        public struct StatusParameters {
            // Path
            
            var id: String
            
            // Query
            
            var maxId: String?
            var sinceId: String?
            var minId: String?
            
            var limit: Int?
            
            var onlyMedia: Bool?
            var excludeReplies: Bool?
            var excludeReblogs: Bool?
            
            var pinned: Bool?
            var tagged: String?
            
            public init(
                id: String,
                maxId: String? = nil,
                sinceId: String? = nil,
                minId: String? = nil,
                limit: Int? = nil,
                onlyMedia: Bool? = nil,
                excludeReplies: Bool? = nil,
                excludeReblogs: Bool? = nil,
                pinned: Bool? = nil,
                tagged: String? = nil
            ) {
                self.id = id
                self.maxId = maxId
                self.sinceId = sinceId
                self.minId = minId
                self.limit = limit
                self.onlyMedia = onlyMedia
                self.excludeReplies = excludeReplies
                self.excludeReblogs = excludeReblogs
                self.pinned = pinned
                self.tagged = tagged
            }
            
            var queryItems: [URLQueryItem?]? {
                [
                    URLQueryItem("max_id", value: maxId),
                    URLQueryItem("since_id", value: sinceId),
                    URLQueryItem("min_id", value: minId),
                    URLQueryItem("limit", value: limit?.description),
                    URLQueryItem("only_media", value: onlyMedia?.description),
                    URLQueryItem("exclude_replies", value: excludeReplies?.description),
                    URLQueryItem("exclude_reblogs", value: excludeReblogs?.description),
                    URLQueryItem("pinned", value: pinned?.description),
                    URLQueryItem("tagged", value: tagged)
                ]
            }
        }
    }
}

extension Mastodon.Account: TargetType {
    private var apiPath: String { "/api/\(api.rawValue)/accounts" }

    var path: String {
        switch self {
        case .account(let id):
            return "\(apiPath)/\(id)"
        case .verifyCredentials:
            return "\(apiPath)/verify_credentials"
        case .followers(let id):
            return "\(apiPath)/\(id)/followers"
        case .following(let id):
            return "\(apiPath)/\(id)/following"
        case let .status(parameters):
            return "\(apiPath)/\(parameters.id)/statuses"
        case .follow(let id):
            return "\(apiPath)/\(id)/follow"
        case .unfollow(let id):
            return "\(apiPath)/\(id)/unfollow"
        case .block(let id):
            return "\(apiPath)/\(id)/block"
        case .unblock(let id):
            return "\(apiPath)/\(id)/unblock"
        case .mute(let id):
            return "\(apiPath)/\(id)/mute"
        case .unmute(let id):
            return "\(apiPath)/\(id)/unmute"
        case .relationships(_):
            return "\(apiPath)/relationships"
        case .search(_, _):
            return "\(apiPath)/search"
        }
    }
    
    var method: Method {
        switch self {
        case .follow:
            return .post
        case .unfollow:
            return .post
        default:
            return .get
        }
    }
        
    var queryItems: [URLQueryItem?]? {
        switch self {
        case let .status(parameters):
            return parameters.queryItems
        case .relationships(let ids):
            return ids.map {
              URLQueryItem("id[]", value: $0)
            }
        case .search(let query, let limit):
            return [
                URLQueryItem("q", value: query),
                URLQueryItem("limit", value: limit.description)
            ]
        default:
            return nil
        }
    }
}
