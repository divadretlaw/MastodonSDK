//
//  HTMLString.swift
//  MastodonSDK
//
//  Created by David Walter on 16.01.23.
//

import Foundation
import HTML2Markdown

public struct HTMLString: Codable, Equatable, Hashable {    
    public var raw: String
    public var markdown: String
    
    public init(raw: String) {
        self.raw = raw
        
        var parsed: String
        do {
            parsed = try HTMLParser().parse(html: raw)
                .markdownFormatted(options: [.mastodon])
        } catch {
            parsed = raw
        }
        
        if let regex = HTMLString.accountRegex {
            parsed = regex.stringByReplacingMatches(in: parsed, range: NSRange(location: 0, length: parsed.utf16.count), withTemplate: "<mastodon/>$0<mastodon/>")
                .components(separatedBy: "<mastodon/>")
                .map {
                    if !regex.matches(in: $0).isEmpty {
                        let url = $0.split(separator: "@", omittingEmptySubsequences: true)
                            .reversed()
                            .joined(separator: "/@")
                        
                        return "[\($0)](https://\(url))"
                    } else {
                        return $0
                    }
                }
                .joined()
        }
        
        self.markdown = parsed
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self.init(raw: value)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(raw)
    }
    
    static let accountRegex = try? NSRegularExpression(pattern: "@[A-Za-z0-9-]+@[A-Za-z0-9-]{1,63}\\.[A-Za-z]{2,6}")
    
    public var isEmpty: Bool {
        markdown.isEmpty
    }
    
    @available(iOS 15, *)
    public var attributedString: AttributedString {
        do {
            let options = AttributedString.MarkdownParsingOptions(allowsExtendedAttributes: true,
                                                                  interpretedSyntax: .inlineOnlyPreservingWhitespace)
            return try AttributedString(markdown: markdown, options: options)
        } catch {
            return AttributedString(stringLiteral: markdown)
        }
    }
}
