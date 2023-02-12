import Foundation

extension Mastodon {
    enum Media {
        case upload(Data, String)
    }
}

extension Mastodon.Media: TargetType {
    private var apiPath: String { "/api/\(api.rawValue)/media" }

    var path: String {
        switch self {
        case .upload:
            return "\(apiPath)"
        }
    }
    
    var method: Method {
        switch self {
        case .upload:
            return .post
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .upload:
            return ["content-type": "multipart/form-data; boundary=\(UUID().uuidString)"]
        }
    }
    
    var httpBody: Data? {
        switch self {
        case .upload(let data, let mimeType):
            return data.createMultipartFormDataBuilder(withBoundary: UUID().uuidString)?
                .addDataField(named: "file", data: data, mimeType: mimeType)
                .build()
        }
    }
}
