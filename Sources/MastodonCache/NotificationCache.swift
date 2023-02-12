//
//  NotificationCache.swift
//  MastodonSDK
//
//  Created by David Walter on 05.02.23.
//

import Foundation
import MastodonSDK
import Boutique

public class NotificationCache: StatusUpdateableCache {
    let store: Store<MastodonSDK.Notification>
    
    public init() {
        self.store = Store<MastodonSDK.Notification>(
            storage: SQLiteStorageEngine.default(appendingPath: "notifactions"),
            cacheIdentifier: \.id
        )
    }
    
    public var publisher: Published<[MastodonSDK.Notification]>.Publisher {
        store.$items
    }
    
    @MainActor public var items: [MastodonSDK.Notification] {
        store.items
    }
    
    public func insert(notification: MastodonSDK.Notification) async throws {
        try await store.insert(notification)
    }
    
    public func insert(notifications: [MastodonSDK.Notification]) async throws {
        try await store.insert(notifications)
    }
    
    public func update(notification: MastodonSDK.Notification?) async throws {
        guard let notification = notification, await store.items.contains(where: { $0.id == notification.id }) else { return }
        try await store.insert(notification)
    }
    
    public func removeAll() async throws {
        try await store.removeAll()
    }
    
    public func cleanUp() async throws {
        let items = await store.items
            .sorted { lhs, rhs in
                lhs.createdAt > rhs.createdAt
            }
            .prefix(100)
            .map { $0 }
        try await store.removeAll().insert(items).run()
    }
    
    // MARK: - StatusUpdateableCache
    
    public func update(status: MastodonSDK.Status?) async throws {
        guard let status = status else { return }
        let notifications = await self.items
            .filter { $0.status?.id == status.id }
            .map {
                $0.update(status: status)
            }
        try await store.insert(notifications)
    }
}
