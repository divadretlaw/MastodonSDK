import Foundation

public struct Mention: Codable, Equatable, Hashable {
    public let url: URL
    public let username: String
    public let acct: String
    public let id: String
    
    public var fullUsername: String {
        guard let host = url.host else { return username }
        return "\(username)@\(host)"
    }
}
