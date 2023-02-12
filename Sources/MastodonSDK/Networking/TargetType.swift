//
//  TargetType.swift
//  MastodonSwift
//
//  Created by Marcus Kida on 31.10.22.
//

import Foundation

public enum Method: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case head = "HEAD"
    case patch = "PATCH"
}

public enum ApiVersion: String {
    case v1 = "v1"
    case v2 = "v2"
}

protocol TargetType {
    var path: String { get }
    var method: Method { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem?]? { get }
    var httpBody: Data? { get }
    
    var api: ApiVersion { get }
}

extension TargetType {
    var headers: [String: String]? {
        ["content-type": "application/json"]
    }
    
    var method: Method { .get }
    
    var httpBody: Data? { nil }
    
    var queryItems: [URLQueryItem?]? { nil }
    
    var api: ApiVersion { .v1 }
}
