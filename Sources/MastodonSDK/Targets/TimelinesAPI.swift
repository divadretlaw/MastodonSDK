import Foundation

extension Mastodon {
    enum Timelines {
        case home(_ maxId: String?, _ sinceId: String?, _ minId: String?, _ limit: Int?)
        case pub(_ local: Bool, _ maxId: String?, _ sinceId: String?, _ minId: String?, _ limit: Int?)
        case tag(_ tag: String, _ maxId: String?, _ sinceId: String?, _ minId: String?, _ limit: Int?)
    }
}

extension Mastodon.Timelines: TargetType {
    private var apiPath: String { "/api/\(api.rawValue)/timelines" }

    var path: String {
        switch self {
        case .home:
            return "\(apiPath)/home"
        case .pub:
            return "\(apiPath)/public"
        case .tag(let hashtag, _, _, _, _):
            return "\(apiPath)/tag/\(hashtag)"
        }
    }
    
    var method: Method {
        switch self {
        default:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem?]? {
        var local: Bool? = nil
        var maxId: String? = nil
        var sinceId: String? = nil
        var minId: String? = nil
        var limit: Int? = nil

        switch self {
        case .tag(_, let _maxId, let _sinceId, let _minId, let _limit):
            maxId = _maxId
            sinceId = _sinceId
            minId = _minId
            limit = _limit
        case .home(let _maxId, let _sinceId, let _minId, let _limit):
            maxId = _maxId
            sinceId = _sinceId
            minId = _minId
            limit = _limit
        case .pub(let _local, let _maxId, let _sinceId, let _minId, let _limit):
            local = _local
            maxId = _maxId
            sinceId = _sinceId
            minId = _minId
            limit = _limit
        }

        return [
            URLQueryItem("max_id",  value: maxId),
            URLQueryItem("since_id", value: sinceId),
            URLQueryItem("min_id", value: minId),
            URLQueryItem("limit", value: limit?.description),
            URLQueryItem("local", value: local?.description)
        ]
    }
}
