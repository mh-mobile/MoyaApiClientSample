//
//  LoginResponse.swift
//
//  Created by maru on 2017/09/19.
//

import Foundation

struct LoginResponse: Codable {
    var sessionKey: String
    
    private enum CodingKeys: String, CodingKey {
        case sessionKey = "session_key"
    }
}
