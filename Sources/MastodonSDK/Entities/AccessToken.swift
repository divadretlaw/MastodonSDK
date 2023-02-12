import Foundation
import AppAuth

public struct AccessToken: Codable {
    public let accessToken: String?
    
    public init(credential: OIDAuthState) {
        self.accessToken = credential.lastTokenResponse?.accessToken
    }
    
    public init(accessToken: String?) {
        self.accessToken = accessToken
    }
}
