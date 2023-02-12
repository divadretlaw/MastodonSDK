import Foundation

public struct Field: Codable, Equatable, Hashable {
    public let name: HTMLString
    public let value: HTMLString
    public let verifiedAt: Date?
}
