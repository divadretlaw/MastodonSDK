import Foundation

public typealias ClientId = String
public typealias ClientSecret = String
public typealias UsernameType = String
public typealias PasswordType = String

extension Mastodon {
    enum OAuth {
        case authenticate(App, UsernameType, PasswordType, String?)
    }
}

extension Mastodon.OAuth: TargetType {
    struct Request: Encodable {
        let clientId: String
        let clientSecret: String
        let grantType: String
        let username: String
        let password: String
        let scope: String
    }
    
    private var apiPath: String { "/oauth/token" }
    
    var path: String {
        switch self {
        case.authenticate(_, _, _, _):
            return "\(apiPath)"
        }
    }
    
    var method: Method {
        switch self {
        case .authenticate:
            return .post
        }
    }
    
    var httpBody: Data? {
        switch self {
        case .authenticate(let app, let username, let password, let scope):
            return try? MastodonClient.jsonEncoder.encode(
                Request(
                    clientId: app.clientId,
                    clientSecret: app.clientSecret,
                    grantType: "password",
                    username: username,
                    password: password,
                    scope: scope ?? ""
                )
            )
        }
    }
}
