import Foundation

extension Mastodon {
    enum Notifications {
        case notifications(parameters: GetParameters)
        case notification(String)
        case clear
        
        public struct GetParameters {
            var maxId: String?
            var sinceId: String?
            var minId: String?
            var limit: Int?
            var types: [Notification.NotificationType]?
            var excludeTypes: [Notification.NotificationType]?
            var accountId: String?
            
            public init(
                maxId: String? = nil,
                sinceId: String? = nil,
                minId: String? = nil,
                limit: Int? = nil,
                types: [Notification.NotificationType]? = nil,
                excludeTypes: [Notification.NotificationType]? = nil,
                accountId: String? = nil
            ) {
                self.maxId = maxId
                self.sinceId = sinceId
                self.minId = minId
                self.limit = limit
                self.types = types
                self.excludeTypes = excludeTypes
                self.accountId = accountId
            }
            
            var queryItems: [URLQueryItem?]? {
                [
                    URLQueryItem("max_id", value: maxId),
                    URLQueryItem("since_id", value: sinceId),
                    URLQueryItem("min_id", value: minId),
                    URLQueryItem("limit", value: limit?.description),
//                    URLQueryItem("types", value: types?.description),
//                    URLQueryItem("exclude_types", value: excludeTypes?.description),
                    URLQueryItem("accound_id", value: accountId)
                ]
            }
        }
    }
}

extension Mastodon.Notifications: TargetType {
    private var apiPath: String { "/api/\(api.rawValue)/notifications" }

    var path: String {
        switch self {
        case .notifications:
            return "\(apiPath)"
        case .notification(let id):
            return "\(apiPath)/\(id)"
        case .clear:
            return "\(apiPath)/clear"
        }
    }
    
    var method: Method {
        switch self {
        case .notifications, .notification:
            return .get
        case .clear:
            return .post
        }
    }
    
    var queryItems: [URLQueryItem?]? {
        switch self {
        case let .notifications(parameters):
            return parameters.queryItems
        default:
            return nil
        }
    }
}
