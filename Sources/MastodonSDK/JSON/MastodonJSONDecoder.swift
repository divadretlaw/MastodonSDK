//
//  MastodonJSONDecoder.swift
//  MastodonSDK
//
//  Created by David Walter on 21.12.22.
//

import Foundation

public class MastodonJSONDecoder: JSONDecoder {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static var dateFormats: [String] {
        [
            "yyyy-MM-dd",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd'T'HH:mm:ssZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        ]
    }
    
    public override init() {
        super.init()
        self.keyDecodingStrategy = .convertFromSnakeCase
        self.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            
            if let date = Self.dateFormatter.date(from: rawValue, withFormats: Self.dateFormats) {
                return date
            }
            
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid date format"))
        }
    }
    
    public override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        #if DEBUG
//        if let json = String(data: data, encoding: .utf8) {
//            print(json)
//        }
        #endif
        return try super.decode(type, from: data)
    }
}

extension DateFormatter {
    func date(from rawValue: String, withFormats: [String]) -> Date? {
        let currentFormat = self.dateFormat
        
        for dateFormat in withFormats {
            self.dateFormat = dateFormat
            if let date = self.date(from: rawValue) {
                return date
            }
        }
        
        self.dateFormat = currentFormat
        return nil
    }
}

#if DEBUG
extension Data {
    func printJSON() {
        guard let json = String(data: self, encoding: .utf8) else { return }
        print(json)
    }
}
#endif
