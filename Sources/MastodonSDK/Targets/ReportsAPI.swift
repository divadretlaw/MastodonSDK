import Foundation

extension Mastodon {
    enum Reports {
        case list
        case report(String, [String], String)
    }
}

extension Mastodon.Reports: TargetType {
    private struct Request: Encodable {
        let accountId: String
        let statusIds: [String]
        let comment: String
    }
    
    private var apiPath: String { "/api/\(api.rawValue)/reports" }

    var path: String {
        switch self {
        case .list, .report(_, _, _):
            return "\(apiPath)"
        }
    }
    
    var method: Method {
        switch self {
        case .list:
            return .get
        case .report:
            return .post
        }
    }
    
    var httpBody: Data? {
        switch self {
        case .list:
            return nil
        case .report(let accountId, let statusIds, let comment):
            return try? MastodonClient.jsonEncoder.encode(
                Request(accountId: accountId, statusIds: statusIds, comment: comment)
            )
        }
    }
}
