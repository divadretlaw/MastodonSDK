import Foundation

extension Mastodon {
    enum FollowRequests {
        case followRequests
        case authorize(String)
        case reject(String)
    }
}

extension Mastodon.FollowRequests: TargetType {
    private var apiPath: String { "/api/\(api.rawValue)/follow_requests" }
    
    var path: String {
        switch self {
        case .followRequests:
            return "\(apiPath)"
        case .authorize(_):
            return "\(apiPath)/authorize"
        case .reject(_):
            return "\(apiPath)/reject"
        }
    }
    
    var method: Method {
        switch self {
        case .followRequests:
            return .get
        case .authorize, .reject:
            return .post
        }
    }
    
    var httpBody: Data? {
        switch self {
        case .followRequests:
            return nil
        case .authorize(let id):
            return try? MastodonClient.jsonEncoder.encode(
                ["id": id]
            )
        case .reject:
            return nil
        }
    }
}
