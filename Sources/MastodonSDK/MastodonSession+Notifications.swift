//
//  MastodonSession+Notifications.swift
//  MastodonSDK
//
//  Created by David Walter on 01.01.23.
//

import Foundation

public extension MastodonSession {
    var notifications: NotificationsAPI {
        NotificationsAPI(session: self)
    }
    
    class NotificationsAPI: MastodonAPI {
        public func get(
            maxId: String? = nil,
            sinceId: String? = nil,
            minId: String? = nil,
            limit: Int? = nil,
            types: [Notification.NotificationType]? = nil,
            excludeTypes: [Notification.NotificationType]? = nil,
            accountId: String? = nil
        ) async throws -> [Notification] {
            let parameters = Mastodon.Notifications.GetParameters(
                maxId: maxId,
                sinceId: sinceId,
                minId: minId,
                limit: limit,
                types: types,
                excludeTypes: excludeTypes,
                accountId: accountId)
            
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Notifications.notifications(parameters: parameters),
                withBearerToken: token
            )
            
            let (data, _) = try await urlSession.data(for: request)
            
            return try Self.jsonDecoder.decode([Notification].self, from: data)
        }
    }
}
