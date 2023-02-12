import Foundation

public struct CustomEmoji: Codable, Equatable, Hashable {
    public let shortcode: String
    public let url: URL
    public let staticUrl: URL
    public let visibleInPicker: Bool
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(shortcode)
    }
}
