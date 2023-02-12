//
//  MastodonSession+Accounts.swift
//  MastodonSDK
//
//  Created by Thomas Bonk on 06.11.22.
//

import Foundation

public extension MastodonSession {
    var account: AccountAPI {
        AccountAPI(session: self)
    }
    
    class AccountAPI: MastodonAPI {
        public func verifyCredentials() async throws -> Account {
            let request = try MastodonSession.request(
                for: session.baseURL,
                target: Mastodon.Account.verifyCredentials,
                withBearerToken: session.token
            )
            
            let (data, _) = try await session.urlSession.data(for: request)
            
            return try MastodonSession.jsonDecoder.decode(Account.self, from: data)
        }
        
        public func get(id: String) async throws -> Account {
            let request = try MastodonSession.request(
                for: session.baseURL,
                target: Mastodon.Account.account(id),
                withBearerToken: session.token
            )
            
            let (data, _) = try await session.urlSession.data(for: request)
            
            return try MastodonSession.jsonDecoder.decode(Account.self, from: data)
        }
        
        public func getId(acct: String) async throws -> String? {
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Search.account(acct),
                withBearerToken: token
            )
            
            let (data, _) = try await urlSession.data(for: request)
            
            let result = try Self.jsonDecoder.decode(Result.self, from: data)
            
            return result.accounts.first?.id
        }
        
        public func relationship(ids: [String]) async throws -> [Relationship] {
            let request = try MastodonSession.request(
                for: session.baseURL,
                target: Mastodon.Account.relationships(ids),
                withBearerToken: session.token
            )
            
            let (data, _) = try await session.urlSession.data(for: request)
            
            return try MastodonSession.jsonDecoder.decode([Relationship].self, from: data)
        }
        
        public func getStatus(
            id: String,
            maxId: String? = nil,
            sinceId: String? = nil,
            minId: String? = nil,
            limit: Int? = nil,
            onlyMedia: Bool? = nil,
            excludeReplies: Bool? = nil,
            excludeReblogs: Bool? = nil,
            pinned: Bool? = nil,
            tagged: String? = nil
        ) async throws -> [Status] {
            let parameters = Mastodon.Account.StatusParameters(
                id: id,
                maxId: maxId,
                sinceId: sinceId,
                minId: minId,
                limit: limit,
                onlyMedia: onlyMedia,
                excludeReplies: excludeReplies,
                excludeReblogs: excludeReblogs,
                pinned: pinned,
                tagged: tagged
            )
            
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Account.status(parameters: parameters),
                withBearerToken: token
            )
            
            let (data, _) = try await urlSession.data(for: request)
            
            return try Self.jsonDecoder.decode([Status].self, from: data)
        }
        
        public func follow(id: String) async throws -> Relationship {
            let request = try MastodonSession.request(
                for: session.baseURL,
                target: Mastodon.Account.follow(id),
                withBearerToken: session.token
            )
            
            let (data, _) = try await session.urlSession.data(for: request)
            
            return try MastodonSession.jsonDecoder.decode(Relationship.self, from: data)
        }
        
        public func unfollow(id: String) async throws -> Relationship {
            let request = try MastodonSession.request(
                for: session.baseURL,
                target: Mastodon.Account.unfollow(id),
                withBearerToken: session.token
            )
            
            let (data, _) = try await session.urlSession.data(for: request)
            
            return try MastodonSession.jsonDecoder.decode(Relationship.self, from: data)
        }
    }
}
