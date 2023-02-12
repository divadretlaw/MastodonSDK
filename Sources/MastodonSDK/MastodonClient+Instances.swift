//
//  File.swift
//  
//
//  Created by Thomas Bonk on 11.11.22.
//

import Foundation

public extension MastodonClient {
    func readInstanceInformation() async throws -> Instance {
        let request = try Self.request(for: baseURL, target: Mastodon.Instances.instance )
        let (data, _) = try await urlSession.data(for: request)

        return try Self.jsonDecoder.decode(Instance.self, from: data)
    }
}

public extension MastodonSession {
    var instances: InstancesAPI {
        InstancesAPI(session: self)
    }
    
    class InstancesAPI: MastodonAPI {
        public func peers() async throws -> [String] {
            let request = try Self.request(
                for: baseURL,
                target: Mastodon.Instances.peers,
                withBearerToken: token
            )
            
            let (data, _) = try await urlSession.data(for: request)
            
            return try Self.jsonDecoder.decode([String].self, from: data)
        }
    }
}
