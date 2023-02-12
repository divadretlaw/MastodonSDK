//
//  HomeTimelineCache.swift
//  MastodonCache
//
//  Created by David Walter on 29.01.23.
//

import Foundation
import MastodonSDK
import Boutique
import Combine

public class HomeTimelineCache: StatusCache {
    let store: Store<Status>
    
    public init(acct: String) {
        self.store = Store<Status>(
            storage: SQLiteStorageEngine.default(appendingPath: "\(acct)/status"),
            cacheIdentifier: \.id
        )
    }
    
    public var publisher: Published<[Status]>.Publisher {
        store.$items
    }
    
    @MainActor public var items: [Status] {
        store.items
    }
    
    public func insert(status: Status) async throws {
        try await store.insert(status)
    }
    
    public func insert(status: [Status]) async throws {
        try await store.insert(status)
    }
    
    public func update(status: Status?) async throws {
        guard let status = status, await store.items.contains(where: { $0.id == status.id }) else { return }
        try await store.insert(status)
    }
    
    public func removeAll() async throws {
        try await store.removeAll()
    }
    
    public func cleanUp() async throws {
        let items = await store.items
        guard items.count > 200 else { return }
        
        let updated = items
            .sorted { lhs, rhs in
                lhs.createdAt > rhs.createdAt
            }
            .prefix(100)
            .map { $0 }
        
        try await store.removeAll().insert(updated).run()
    }
}
