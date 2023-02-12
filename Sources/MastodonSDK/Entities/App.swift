import Foundation

public struct App: Codable {
    public let id: String
    public let name: String
    public let website: String?
    public let redirectUri: String
    public let clientId: String
    public let clientSecret: String
    public let vapidKey: String

    public init(clientId: String, clientSecret: String, vapidKey: String = "") {
        self.id = ""
        self.name = ""
        self.redirectUri = "urn:ietf:wg:oauth:2.0:oob"
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.website = nil
        self.vapidKey = vapidKey
    }
}
