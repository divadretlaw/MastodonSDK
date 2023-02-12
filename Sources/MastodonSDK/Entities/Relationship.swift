import Foundation

public struct Relationship: Codable, Identifiable, Equatable, Hashable {
    public let id: String
    public let following: Bool
    public let showingReblogs: Bool
    public let notifying: Bool
    public let languages: [String]?
    public let followedBy: Bool
    public let blocking: Bool
    public let blockedBy: Bool
    public let muting: Bool
    public let mutingNotifications: Bool
    public let requested: Bool
    public let domainBlocking: Bool
    public let endorsed: Bool
    public let note: HTMLString
}
