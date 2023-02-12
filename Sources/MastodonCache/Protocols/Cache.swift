//
//  Cache.swift
//  MastodonCache
//
//  Created by David Walter on 05.02.23.
//

import Foundation

public protocol Cache {
    associatedtype Element
    
    var publisher: Published<[Element]>.Publisher { get }
    @MainActor var items: [Element] { get }
    
    func insert(element: Element) async throws
    func insert(elements: [Element]) async throws
    func update(element: Element?) async throws
    func removeAll() async throws
}
