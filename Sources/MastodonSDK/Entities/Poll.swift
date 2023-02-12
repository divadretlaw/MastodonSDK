import Foundation

public struct Poll: Codable, Equatable, Hashable {
    public let id: String
    public let expiresAt: Date?
    public let expired: Bool
    public let multiple: Bool
    public let votesCount: Int
    public let options: [Option]
    public let emojis: [CustomEmoji]
    public let voted: Bool?
    public let ownVotes: [Int]?
    
    public struct Option: Codable, Equatable, Hashable {
        public let title: String
        public let votesCount: Int?
        
        public var value: Double {
            Double(votesCount ?? 0)
        }
    }
    
    public var total: Double {
        Double(votesCount)
    }
    
    public var winner: Option? {
        guard expired else { return nil }
        return options.max { lhs, rhs in
            lhs.value < rhs.value
        }
    }
    
    public func didVote(for option: Option) -> Bool {
        guard let ownVotes = ownVotes else { return false }
        guard let index = options.firstIndex(of: option) else { return false }
        return ownVotes.contains(index)
    }
    
    public func formattedPercent(for option: Option) -> String {
        let value = option.value / total
        return value.formatted(.percent.precision(.fractionLength(0))).padding(toLength: 5, withPad: " ", startingAt: 0)
    }
}
