import Foundation

public enum SearchType: String, Codable, Equatable, Hashable {
    case status = "statuses"
    case accounts = "accounts"
    case tags = "tags"
}
