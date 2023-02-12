//
//  Regex.swift
//  MastodonSDK
//
//  Created by David Walter on 18.01.23.
//

import Foundation

extension NSRegularExpression {
    func matches(in string: String) -> [NSTextCheckingResult] {
        matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
    }
}

extension String {
    func substrings(regex: NSRegularExpression) -> [Substring] {
        regex.matches(in: self)
            .compactMap {
                Range($0.range, in: self)
            }
            .map {
                self[$0]
            }
    }
}
