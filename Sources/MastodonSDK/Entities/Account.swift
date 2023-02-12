import Foundation

public class Account: Codable, Equatable, Hashable {
    public let id: String
    public let username: String
    public let acct: String
    public let url: URL?
    public let displayName: HTMLString?
    public let note: HTMLString?
    public let avatar: URL?
    public let avatarStatic: URL?
    public let header: URL?
    public let headerStatic: URL?
    public let locked: Bool
    public let fields: [Field]
    public let emojis: [CustomEmoji]
    public let bot: Bool
    public let group: Bool?
    public let discoverable: Bool?
    
    // public let noindex: Bool?
    public let moved: Account?
    // public let suspended: Bool?
    // public let limited: Bool?
    
    public let createdAt: Date
    public let lastStatusAt: Date?
    public let statusesCount: Int
    public let followersCount: Int
    public let followingCount: Int
    
    public static func == (lhs: Account, rhs: Account) -> Bool {
        guard lhs.id == rhs.id else { return false }
        return true
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    #if DEBUG
    public init(
        id: String,
        username: String,
        acct: String,
        url: URL? = nil,
        displayName: HTMLString? = nil,
        note: HTMLString? = nil,
        avatar: URL? = nil,
        avatarStatic: URL? = nil,
        header: URL? = nil,
        headerStatic: URL? = nil,
        locked: Bool = false,
        fields: [Field] = [],
        emojis: [CustomEmoji] = [],
        bot: Bool = false,
        group: Bool? = nil,
        discoverable: Bool? = nil,
        moved: Account? = nil,
        createdAt: Date,
        lastStatusAt: Date? = nil,
        statusesCount: Int,
        followersCount: Int,
        followingCount: Int) {
        self.id = id
        self.username = username
        self.acct = acct
        self.url = url
        self.displayName = displayName
        self.note = note
        self.avatar = avatar
        self.avatarStatic = avatarStatic
        self.header = header
        self.headerStatic = headerStatic
        self.locked = locked
        self.fields = fields
        self.emojis = emojis
        self.bot = bot
        self.group = group
        self.discoverable = discoverable
        self.moved = moved
        self.createdAt = createdAt
        self.lastStatusAt = lastStatusAt
        self.statusesCount = statusesCount
        self.followersCount = followersCount
        self.followingCount = followingCount
    }
    #endif
    
    public var hasHeader: Bool {
        guard let url = header ?? headerStatic else { return false }
        return url.lastPathComponent.lowercased() != "missing.png"
    }
    
    public static var empty: Account {
        Account(id: "",
                username: "",
                acct: "",
                createdAt: .distantFuture,
                statusesCount: -1,
                followersCount: -1,
                followingCount: -1)
    }
}
