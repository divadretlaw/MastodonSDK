import Foundation

public struct Card: Codable, Equatable, Hashable {
    public let url: URL
    public let title: HTMLString
    public let description: HTMLString
    public let type: CardType

    public let authorName: String?
    public let authorUrl: String?
    public let providerName: String?
    public let providerUrl: String?
    public let html: HTMLString?
    public let width: Int?
    public let height: Int?
    public let image: String?
    public let embedUrl: String?
    public let blurhash: String?
    
    public enum CardType: String, Codable, Equatable, Hashable {
        case link = "link" // Link OEmbed
        case photo = "photo" // Photo OEmbed
        case video = "video" // Video OEmbed
        case rich = "rich" // iframe OEmbed. Not currently accepted, so won't show up in practice.
    }
}
