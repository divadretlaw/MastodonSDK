import Foundation

public struct Error: Codable {
    public let error: String
    public let errorDescription: String?
}
