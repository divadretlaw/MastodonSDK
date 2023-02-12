import Foundation

public struct StatusEdit: Codable, Equatable, Hashable {
    public let content: HTMLString
    public let spoilerText: String
    public let sensitive: Bool
    public let createdAt: Date
    public let account: Account
    // public let poll: Poll?
    public let mediaAttachments: [Attachment]
    public let emojis: [CustomEmoji]
}
