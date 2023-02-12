//
//  MastodonSession+Search.swift
//  MastodonSDK
//
//  Created by David Walter on 22.01.23.
//

import Foundation

public extension MastodonSession {
    var search: SearchAPI {
        SearchAPI(session: self)
    }
    
    class SearchAPI: MastodonAPI {
        public func text(
            _ text: String,
            type: SearchType?
        ) async throws -> Result {
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Search.search(query: text, type: type, true),
                withBearerToken: token
            )
            
            let (data, _) = try await urlSession.data(for: request)
            
            return try Self.jsonDecoder.decode(Result.self, from: data)
        }
    }
}
