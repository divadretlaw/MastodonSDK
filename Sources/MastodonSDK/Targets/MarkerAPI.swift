import Foundation

extension Mastodon {
    public enum Markers {
        public enum Timeline: String, Encodable {
            case home
            case notifications
        }
        
        case set([Timeline: String])
        case read(Set<Timeline>)
    }
}

extension Mastodon.Markers: TargetType {
    private var apiPath: String { "/api/\(api.rawValue)/markers" }
    
    var path: String {
        return apiPath
    }
    
    var method: Method {
        switch self {
        case .set(_):
            return .post
        case .read(_):
            return .get
        }
    }
    
    var queryItems: [URLQueryItem?]? {
        switch self {
        case .set:
            return nil
        case .read(let markers):
            return markers
                .map { URLQueryItem(name: "timeline[]", value: $0.rawValue) }
        }
    }
    
    var httpBody: Data? {
        switch self {
        case .set(let markers):
            let dict = Dictionary(uniqueKeysWithValues: markers.map { ($0.rawValue, ["last_read_id": $1]) })
            let data = try? MastodonClient.jsonEncoder.encode(dict)
            return data
        case .read(_):
            return nil
        }
    }
}
