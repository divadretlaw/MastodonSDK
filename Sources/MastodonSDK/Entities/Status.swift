import Foundation

protocol AnyStatus: Codable, Identifiable, Equatable, Hashable {
    var id: String { get }
    var uri: String { get }
    var url: URL? { get }
    var account: Account { get }
    var repliesCount: Int { get }
    var inReplyToId: String? { get }
    var inReplyToAccountId: String? { get }
    var content: HTMLString  { get }
    var text: String? { get }
    var createdAt: Date { get }
    var editedAt: Date? { get }
    var reblogsCount: Int { get }
    var favouritesCount: Int { get }
    var reblogged: Bool { get }
    var favourited: Bool { get }
    var sensitive: Bool { get }
    var bookmarked: Bool { get }
    var pinned: Bool? { get }
    var muted: Bool { get }
    var spoilerText: String? { get }
    var visibility: StatusVisibility { get }
    var mediaAttachments: [Attachment] { get }
    var card: Card? { get }
    var mentions: [Mention] { get }
    var tags: [HashTag] { get }
    var emojis: [CustomEmoji] { get }
    var application: Application? { get }
}

extension AnyStatus {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public enum StatusVisibility: String, Codable, Equatable, Hashable {
    case `public` = "public"
    case unlisted = "unlisted"
    case `private` = "private"
    case direct = "direct"
}

public struct Status: AnyStatus, CustomDebugStringConvertible {
    public let id: String
    public let uri: String
    public let url: URL?
    public let account: Account
    public let repliesCount: Int
    public let inReplyToId: String?
    public let inReplyToAccountId: String?
    let reblog: ReblogStatus?
    public let content: HTMLString
    public let text: String?
    public let createdAt: Date
    public let editedAt: Date?
    public let reblogsCount: Int
    public let favouritesCount: Int
    public let reblogged: Bool
    public let favourited: Bool
    public let sensitive: Bool
    public let bookmarked: Bool
    public let pinned: Bool?
    public let muted: Bool
    public let spoilerText: String?
    public let visibility: StatusVisibility
    public let mediaAttachments: [Attachment]
    public let poll: Poll?
    public let card: Card?
    public let mentions: [Mention]
    public let tags: [HashTag]
    public let emojis: [CustomEmoji]
    public let application: Application?
    
    #if DEBUG
    public init(id: String,
                uri: String,
                url: URL? = nil,
                account: Account,
                repliesCount: Int,
                inReplyToId: String? = nil,
                inReplyToAccountId: String? = nil,
                // reblog: ReblogStatus? = nil,
                content: HTMLString,
                text: String? = nil,
                createdAt: Date,
                editedAt: Date? = nil,
                reblogsCount: Int,
                favouritesCount: Int,
                reblogged: Bool,
                favourited: Bool,
                sensitive: Bool,
                bookmarked: Bool,
                pinned: Bool? = nil,
                muted: Bool,
                spoilerText: String? = nil,
                visibility: StatusVisibility,
                mediaAttachments: [Attachment],
                poll: Poll? = nil,
                card: Card? = nil,
                mentions: [Mention],
                tags: [HashTag],
                emojis: [CustomEmoji],
                application: Application? = nil) {
        self.id = id
        self.uri = uri
        self.url = url
        self.account = account
        self.repliesCount = repliesCount
        self.inReplyToId = inReplyToId
        self.inReplyToAccountId = inReplyToAccountId
        self.reblog = nil
        self.content = content
        self.text = text
        self.createdAt = createdAt
        self.editedAt = editedAt
        self.reblogsCount = reblogsCount
        self.favouritesCount = favouritesCount
        self.reblogged = reblogged
        self.favourited = favourited
        self.sensitive = sensitive
        self.bookmarked = bookmarked
        self.pinned = pinned
        self.muted = muted
        self.spoilerText = spoilerText
        self.visibility = visibility
        self.mediaAttachments = mediaAttachments
        self.poll = poll
        self.card = card
        self.mentions = mentions
        self.tags = tags
        self.emojis = emojis
        self.application = application
    }
    #endif
    
    init(reblog: ReblogStatus) {
        self.id = reblog.id
        self.uri = reblog.uri
        self.url = reblog.url
        self.account = reblog.account
        self.repliesCount = reblog.repliesCount
        self.inReplyToId = reblog.inReplyToId
        self.inReplyToAccountId = reblog.inReplyToAccountId
        self.reblog = nil
        self.content = reblog.content
        self.text = reblog.text
        self.createdAt = reblog.createdAt
        self.editedAt = reblog.editedAt
        self.reblogsCount = reblog.reblogsCount
        self.favouritesCount = reblog.favouritesCount
        self.reblogged = reblog.reblogged
        self.favourited = reblog.favourited
        self.sensitive = reblog.sensitive
        self.bookmarked = reblog.bookmarked
        self.pinned = reblog.pinned
        self.muted = reblog.muted
        self.spoilerText = reblog.spoilerText
        self.visibility = reblog.visibility
        self.mediaAttachments = reblog.mediaAttachments
        self.poll = reblog.poll
        self.card = reblog.card
        self.mentions = reblog.mentions
        self.tags = reblog.tags
        self.emojis = reblog.emojis
        self.application = reblog.application
    }
    
    public var reblogStatus: Status? {
        guard let reblog = self.reblog else { return nil }
        return Status(reblog: reblog)
    }
    
    public func mention(for url: URL) -> Mention? {
        let status = reblogStatus ?? self
        return status.mentions.first { $0.url == url }
    }
    
    public func tag(for url: URL) -> HashTag? {
        let status = reblogStatus ?? self
        return status.tags.first { $0.url == url }
    }
    
    public func reblog(api: MastodonSession) async throws -> Status {
        if reblogged {
            return try await api.status.unreblog(statusId: id)
        } else {
            let status = try await api.status.reblog(statusId: id)
            return status.reblogStatus ?? status
        }
    }
    
    public func favorite(api: MastodonSession) async throws -> Status {
        if favourited {
            return try await api.status.unfavorite(statusId: id)
        } else {
            return try await api.status.favorite(statusId: id)
        }
    }
    
    public var description: String {
        return "[Status: \(id)]"
    }
    
    public var debugDescription: String {
        do {
            let debugEncoder = JSONEncoder()
            debugEncoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
            let data = try debugEncoder.encode(self)
            return String(data: data, encoding: .utf8) ?? self.description
        } catch {
            return self.description
        }
    }
}

internal struct ReblogStatus: AnyStatus {
    let id: String
    let uri: String
    let url: URL?
    let account: Account
    let repliesCount: Int
    let inReplyToId: String?
    let inReplyToAccountId: String?
    let content: HTMLString
    let text: String?
    let createdAt: Date
    let editedAt: Date?
    let reblogsCount: Int
    let favouritesCount: Int
    let reblogged: Bool
    let favourited: Bool
    let sensitive: Bool
    let bookmarked: Bool
    let pinned: Bool?
    let muted: Bool
    let spoilerText: String?
    let visibility: StatusVisibility
    let mediaAttachments: [Attachment]
    let poll: Poll?
    let card: Card?
    let mentions: [Mention]
    let tags: [HashTag]
    let emojis: [CustomEmoji]
    let application: Application?
}
