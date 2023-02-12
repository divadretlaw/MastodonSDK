//
//  TimelineCache.swift
//  MastodonCache
//
//  Created by David Walter on 29.01.23.
//

import Foundation
import MastodonSDK
import Boutique
import Combine

public class TimelineCache: StatusCache {
    let identifier: String
    
    @Published var store: Set<Status>
    @Published var published: [Status]
    
    private var cancellables = [AnyCancellable]()
    
    public init(identifier: String) {
        self.identifier = identifier
        self.store = []
        self.published = []
        
        $store
            .receive(on: DispatchQueue.main)
            .sink { value in
                self.published = value.map { $0 }
            }
            .store(in: &cancellables)
    }
    
    public var publisher: Published<[Status]>.Publisher {
        $published
    }
    
    public var items: [Status] {
        store.map { $0 }
    }
    
    public func insert(status: Status) async throws {
        store.update(status)
    }
    
    public func insert(status: [Status]) async throws {
        store.update(contentsOf: status)
    }
    
    public func update(status: Status?) async throws {
        guard let status = status, store.contains(where: { $0.id == status.id }) else { return }
        store.update(status)
    }
    
    public func removeAll() async throws {
        store = []
    }
    
    public func cleanUp() async throws {
        
    }
}
