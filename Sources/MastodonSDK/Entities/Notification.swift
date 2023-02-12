import Foundation

public struct Notification: Codable, Identifiable, Equatable, Hashable {
    public let id: String
    public let type: NotificationType
    public let createdAt: Date
    public let account: Account
    public private(set) var status: Status?
    
    public enum NotificationType: String, Codable {
        case mention = "mention"
        case status = "status"
        case reblog = "reblog"
        case follow = "follow"
        case followRequest = "follow_request"
        case favourite = "favourite"
        case poll = "poll"
        case update = "update"
        // Admin
        case adminSignUp = "admin.sign_up"
        case adminReport = "admin.report"
    }
    
    #if DEBUG
    public init(
        id: String,
        type: Notification.NotificationType,
        createdAt: Date,
        account: Account,
        status: Status? = nil
    ) {
        self.id = id
        self.type = type
        self.createdAt = createdAt
        self.account = account
        self.status = status
    }
    #endif
    
    public func update(status: Status) -> Self {
        var value = self
        value.status = status
        return value
    }
}
