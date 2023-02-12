//
//  MastodonAPI.swift
//  MastodonSDK
//
//  Created by David Walter on 21.01.23.
//

import Foundation

public class MastodonAPI: Networker {
    weak internal var session: MastodonSession!
    
    internal init(session: MastodonSession) {
        self.session = session
    }
    
    internal var token: String {
        session.token
    }
    
    internal var baseURL: URL {
        session.baseURL
    }
    
    internal var urlSession: URLSession {
        session.urlSession
    }
}
