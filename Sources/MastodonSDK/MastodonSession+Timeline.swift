//
//  MastodonSession+Timeline.swift
//  MastodonSDK
//
//  Created by David Walter on 12.02.23.
//

import Foundation

extension MastodonSession {
    public func getHomeTimeline(
        maxId: String? = nil,
        sinceId: String? = nil,
        minId: String? = nil,
        limit: Int? = nil
    ) async throws -> [Status] {
        let request = try Self.request(
            for: baseURL,
            target: Mastodon.Timelines.home(maxId, sinceId, minId, limit),
            withBearerToken: token
        )
        
        let (data, _) = try await urlSession.data(for: request)
        
        return try Self.jsonDecoder.decode([Status].self, from: data)
    }
    
    public func getPublicTimeline(
        isLocal: Bool = false,
        maxId: String? = nil,
        sinceId: String? = nil,
        minId: String? = nil,
        limit: Int? = nil
    ) async throws -> [Status] {
        let request = try Self.request(
            for: baseURL,
            target: Mastodon.Timelines.pub(isLocal, maxId, sinceId, minId, limit),
            withBearerToken: token
        )
        
        let (data, _) = try await urlSession.data(for: request)
        
        return try Self.jsonDecoder.decode([Status].self, from: data)
    }
    
    public func getTagTimeline(
        tag: String,
        maxId: String? = nil,
        sinceId: String? = nil,
        minId: String? = nil,
        limit: Int? = nil
    ) async throws -> [Status] {
        let request = try Self.request(
            for: baseURL,
            target: Mastodon.Timelines.tag(tag, maxId, sinceId, minId, limit),
            withBearerToken: token
        )
        
        let (data, _) = try await urlSession.data(for: request)
        
        return try Self.jsonDecoder.decode([Status].self, from: data)
    }
}
