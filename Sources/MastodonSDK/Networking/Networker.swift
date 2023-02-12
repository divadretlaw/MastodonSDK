//
//  Networker.swift
//  MastodonSDK
//
//  Created by David Walter on 01.01.23.
//

import Foundation

protocol Networker {
    static func request(for baseURL: URL, target: TargetType, withBearerToken token: String?) throws -> URLRequest
    
    static var jsonDecoder: JSONDecoder { get }
    static var jsonEncoder: JSONEncoder { get }
}

extension Networker {
    static func request(for baseURL: URL, target: TargetType, withBearerToken token: String? = nil) throws -> URLRequest {
        var urlComponents = URLComponents(url: baseURL.appendingPathComponent(target.path), resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = target.queryItems?.compactMap { $0 }
        
        guard let url = urlComponents?.url else { throw MastodonError.cannotCreateUrlRequest }
        
        var request = URLRequest(url: url)
        
        target.headers?.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpMethod = target.method.rawValue
        request.httpBody = target.httpBody
        
        return request
    }
    
    static var jsonDecoder: JSONDecoder {
        MastodonJSONDecoder()
    }
    
    static var jsonEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
}
