//
//  WebApiConfiguration.swift
//
//  Created by maru on 2017/09/19.
//

import Foundation

enum WebApiEnvironment {
    case development
    case production
    
    func baseDomain() -> String {
        switch self {
        case .development:
            return "https://dev.example.com"
        case .production:
            return "https://www.example.com"
        }
    }
}
