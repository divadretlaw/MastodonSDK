import Foundation

extension Mastodon {
    enum Instances {
        case instance
        case peers
    }
}

extension Mastodon.Instances: TargetType {
    private var apiPath: String { "/api/\(api.rawValue)/instance" }

    var path: String {
        switch self {
        case .instance:
            return apiPath
        case .peers:
            return "\(apiPath)/peers"
        }
    }
    
    var method: Method {
        switch self {
        case .instance:
            return .get
        case .peers:
            return .get
        }
    }
}
