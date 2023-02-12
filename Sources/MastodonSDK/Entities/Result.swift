import Foundation

public struct Result: Codable, Equatable, Hashable {
    public let accounts: [Account]
    public let statuses: [Status]
    public let hashtags: [HashTag]
    
    public var isEmpty: Bool {
        accounts.isEmpty && statuses.isEmpty && hashtags.isEmpty
    }
}
