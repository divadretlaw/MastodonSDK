//
//  MastodonSession+Status.swift
//  MastodonSDK
//
//  Created by David Walter on 01.01.23.
//

import Foundation

public extension MastodonSession {
    var status: StatusAPI {
        StatusAPI(session: self)
    }
    
    class StatusAPI: MastodonAPI {
        public func get(statusId: String) async throws -> Status {
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Status.status(statusId),
                withBearerToken: token
            )
            
            let (data, _) = try await urlSession.data(for: request)
            
            return try Self.jsonDecoder.decode(Status.self, from: data)
        }
        
        public func getHistory(statusId: String) async throws -> [StatusEdit] {
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Status.statusHistory(statusId),
                withBearerToken: token
            )
            
            let (data, _) = try await urlSession.data(for: request)
            
            return try Self.jsonDecoder.decode([StatusEdit].self, from: data).reversed()
        }
        
        public func getRemote(url: URL) async throws -> Status? {
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Search.status(url),
                withBearerToken: token
            )
            
            let (data, _) = try await urlSession.data(for: request)
            
            let result = try Self.jsonDecoder.decode(Result.self, from: data)
            
            return result.statuses.first
        }
        
        public func getId(url: URL) async throws -> String? {
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Search.status(url),
                withBearerToken: token
            )
            
            let (data, _) = try await urlSession.data(for: request)
            
            let result = try Self.jsonDecoder.decode(Result.self, from: data)
            
            return result.statuses.first?.id
        }
        
        public func getContext(statusId: String) async throws -> Context {
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Status.context(statusId),
                withBearerToken: token)
            
            let (data, _) = try await urlSession.data(for: request)
            
            return try Self.jsonDecoder.decode(Context.self, from: data)
        }
        
        // MARK: - Actions
        
        public func read(statusId: String) async throws -> Status {
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Status.status(statusId),
                withBearerToken: token)

            let (data, _) = try await urlSession.data(for: request)

            return try Self.jsonDecoder.decode(Status.self, from: data)
        }

        public func reblog(statusId: String) async throws -> Status {
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Status.reblog(statusId),
                withBearerToken: token
            )
            
            let (data, _) = try await urlSession.data(for: request)
            
            return try Self.jsonDecoder.decode(Status.self, from: data)
        }
        
        public func unreblog(statusId: String) async throws -> Status {
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Status.unreblog(statusId),
                withBearerToken: token
            )
            
            let (data, _) = try await urlSession.data(for: request)
            
            return try Self.jsonDecoder.decode(Status.self, from: data)
        }

        public func bookmark(statusId: String) async throws -> Status {
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Status.bookmark(statusId),
                withBearerToken: token
            )

            let (data, _) = try await urlSession.data(for: request)

            return try Self.jsonDecoder.decode(Status.self, from: data)
        }

        public func unbookmark(statusId: String) async throws -> Status {
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Status.unbookmark(statusId),
                withBearerToken: token
            )

            let (data, _) = try await urlSession.data(for: request)

            return try Self.jsonDecoder.decode(Status.self, from: data)
        }

        public func favorite(statusId: String) async throws -> Status {
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Status.favourite(statusId),
                withBearerToken: token
            )

            let (data, _) = try await urlSession.data(for: request)

            return try Self.jsonDecoder.decode(Status.self, from: data)
        }

        public func unfavorite(statusId: String) async throws -> Status {
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Status.unfavourite(statusId),
                withBearerToken: token
            )

            let (data, _) = try await urlSession.data(for: request)

            return try Self.jsonDecoder.decode(Status.self, from: data)
        }

        public func new(statusComponents: Mastodon.Status.Components) async throws -> Status {
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Status.new(statusComponents),
                withBearerToken: token)

            let (data, _) = try await urlSession.data(for: request)

            return try Self.jsonDecoder.decode(Status.self, from: data)
        }
    }
}
