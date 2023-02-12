import Foundation

public struct Attachment: Codable, Equatable, Hashable {
    public let id: String
    public let type: AttachmentType
    public let url: URL
    public let previewUrl: URL?

    public let remoteUrl: URL?
    public let description: String?
    public let blurhash: String?
    
    public enum AttachmentType: String, Codable, Equatable, Hashable {
        case unknown = "unknown"
        case image = "image"
        case gifv = "gifv"
        case video = "video"
        case audio = "audio"
    }
    
    public init(id: String, type: Attachment.AttachmentType, url: URL, previewUrl: URL? = nil, remoteUrl: URL? = nil, description: String? = nil, blurhash: String? = nil) {
        self.id = id
        self.type = type
        self.url = url
        self.previewUrl = previewUrl
        self.remoteUrl = remoteUrl
        self.description = description
        self.blurhash = blurhash
    }
}
