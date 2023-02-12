//
//  PeerCache.swift
//  MastodonCache
//
//  Created by David Walter on 05.02.23.
//

import Foundation
import Boutique

public class PeerCache {
    let host: String
    let store: Store<String>
    
    public init(url: URL) {
        let host = url.host ?? "mastodon"
        self.host = host
        self.store = Store<String>(
            storage: SQLiteStorageEngine.default(appendingPath: host),
            cacheIdentifier: \.self
        )
    }
    
    public var publisher: Published<[String]>.Publisher {
        store.$items
    }
    
    public func set(peers: [String]) async {
        do {
            try await store
                .removeAll()
                .insert(host)
                .insert(peers)
                .run()
        } catch {
            print(error.localizedDescription)
        }
    }
}
