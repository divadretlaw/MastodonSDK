import Foundation

public struct Context: Codable, Equatable, Hashable {
    public let ancestors: [Status]
    public let descendants: [Status]
    
    public static var empty: Context {
        Context(ancestors: [], descendants: [])
    }
    
    public func ancestorThreads(for status: Status) -> [Context.Thread] {
        let all = ancestors + [status]
        return all.threaded { element in
            element.inReplyToId == status.id
        }
    }
    
    public func descendantThreads(for status: Status) -> [Context.Thread] {
        descendants.threaded { element in
            element.inReplyToId == status.id
        }
    }
    
    public struct Thread: Hashable, Comparable {
        public let status: [Status]
        public let isFirstThread: Bool
        public let isLastThread: Bool
        
        public init(status: [Status], isFirstThread: Bool, isLastThread: Bool) {
            self.status = status
            self.isFirstThread = isFirstThread
            self.isLastThread = isLastThread
        }
        
        public func isFirst(status: Status) -> Bool {
            self.status.first == status
        }
        
        public func isLast(status: Status) -> Bool {
            self.status.last == status
        }
        
        public static func < (lhs: Context.Thread, rhs: Context.Thread) -> Bool {
            guard lhs.status == rhs.status,
                  lhs.isFirstThread == rhs.isFirstThread else {
                return false
            }
            
            return true
        }
    }
}

extension [Status] {
    func threaded(by comparison: (Status) -> Bool) -> [Context.Thread] {
        var result: [Context.Thread] = []
        var array = [Status]()
        let last = self.last
        
        for element in self {
            if comparison(element) {
                if !array.isEmpty {
                    let hasLast = array.contains { $0.id == last?.id }
                    result.append(Context.Thread(status: array, isFirstThread: result.isEmpty, isLastThread: hasLast))
                }
                array = [element]
            } else {
                array.append(element)
            }
        }
        
        if !array.isEmpty {
            result.append(Context.Thread(status: array, isFirstThread: result.isEmpty, isLastThread: true))
        }
        
        return result
    }
}
