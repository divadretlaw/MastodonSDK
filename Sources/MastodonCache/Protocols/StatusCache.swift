//
//  StatusCache.swift
//  MastodonCache
//
//  Created by David Walter on 04.02.23.
//

import Foundation
import MastodonSDK

public protocol StatusCache: StatusUpdateableCache {
    var publisher: Published<[Status]>.Publisher { get }
    @MainActor var items: [Status] { get }

    func insert(status: Status) async throws
    func insert(status: [Status]) async throws
    
    func removeAll() async throws
    func cleanUp() async throws
}

public protocol StatusUpdateableCache {
    func update(status: Status?) async throws
}
