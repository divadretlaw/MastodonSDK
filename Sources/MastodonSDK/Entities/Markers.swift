import Foundation

public struct Marker: Codable {
    public let lastReadId: String
    public let version: Int64
    public let updatedAt: String
}

public struct Markers: Codable {
    public let home: Marker?
    public let notifications: Marker?
}
