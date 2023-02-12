import XCTest
@testable import MastodonCache
import MastodonSDK

class MastodonCacheTests: XCTestCase {
    var cache: HomeTimelineCache!
    
    var account: Account {
        Account(id: "1", username: "divadretlaw", acct: "divadretlaw", createdAt: .distantPast, statusesCount: 1, followersCount: 1, followingCount: 1)
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.cache = try HomeTimelineCache(acct: "divadretlaw")
    }
    
    @MainActor
    func testStatus() async throws {
        let statusA = Status(id: "1",
                             uri: "",
                             url: nil,
                             account: account,
                             repliesCount: 0,
                             inReplyToId: nil,
                             inReplyToAccountId: nil,
                             content: HTMLString(raw: "Hello World"),
                             text: nil,
                             createdAt: Date(),
                             editedAt: nil,
                             reblogsCount: 0,
                             favouritesCount: 0,
                             reblogged: false,
                             favourited: false,
                             sensitive: false,
                             bookmarked: false,
                             pinned: nil,
                             muted: false,
                             spoilerText: nil,
                             visibility: .public,
                             mediaAttachments: [],
                             card: nil,
                             mentions: [],
                             tags: [],
                             emojis: [],
                             application: nil)
        
        try await cache.store.insert(statusA)
       
        XCTAssertFalse(cache.store.items.isEmpty)
        XCTAssertEqual(cache.store.items.count, 1)
        
        let statusB = Status(id: "1",
                             uri: "",
                             url: nil,
                             account: account,
                             repliesCount: 1,
                             inReplyToId: nil,
                             inReplyToAccountId: nil,
                             content: HTMLString(raw: "Hello World"),
                             text: nil,
                             createdAt: Date(),
                             editedAt: nil,
                             reblogsCount: 1,
                             favouritesCount: 1,
                             reblogged: false,
                             favourited: true,
                             sensitive: false,
                             bookmarked: false,
                             pinned: nil,
                             muted: false,
                             spoilerText: nil,
                             visibility: .public,
                             mediaAttachments: [],
                             card: nil,
                             mentions: [],
                             tags: [],
                             emojis: [],
                             application: nil)
        
        try await cache.store.insert(statusB)
        
        XCTAssertFalse(cache.store.items.isEmpty)
        XCTAssertEqual(cache.store.items.count, 1)
    }
}
