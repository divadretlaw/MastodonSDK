import Foundation

public struct HashTag: Codable, Equatable, Hashable {
    public let name: String
    public let url: URL?
    public let following: Bool?
    
    #if DEBUG
    public init(name: String, url: URL? = nil, following: Bool? = nil) {
        self.name = name
        self.url = url
        self.following = following
    }
    #endif
}
