//
//  Set+Extensions.swift
//  MastodonCache
//
//  Created by David Walter on 04.02.23.
//

import Foundation

extension Set {
    mutating func insert(contentsOf collection: [Element]) {
        for element in collection {
            insert(element)
        }
    }
    
    mutating func update(_ member: Element) {
        var copy = self.filter { $0.hashValue != member.hashValue }
        copy.insert(member)
        self = copy
    }
    
    mutating func update(contentsOf collection: [Element]) {
        for element in collection {
            update(element)
        }
    }
}

extension Set where Element: Identifiable {
    func contains(id: Element.ID) -> Bool {
        first { $0.id == id } != nil
    }
}
