//
//  MastodonSession+Trends.swift
//  MastodonSDK
//
//  Created by David Walter on 22.01.23.
//

import Foundation

public extension MastodonSession {
    var trends: TrendsAPI {
        TrendsAPI(session: self)
    }
    
    class TrendsAPI: MastodonAPI {
        public func tags() async throws -> [HashTag] {
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Trends.tags,
                withBearerToken: token
            )
            
            let (data, _) = try await urlSession.data(for: request)
            
            return try Self.jsonDecoder.decode([HashTag].self, from: data)
        }
        
        public func status() async throws -> [Status] {
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Trends.status,
                withBearerToken: token
            )
            
            let (data, _) = try await urlSession.data(for: request)
            
            return try Self.jsonDecoder.decode([Status].self, from: data)
        }
        
        public func links() async throws -> [Card] {
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Trends.links,
                withBearerToken: token
            )
            
            let (data, _) = try await urlSession.data(for: request)
            
            return try Self.jsonDecoder.decode([Card].self, from: data)
        }
    }
}
