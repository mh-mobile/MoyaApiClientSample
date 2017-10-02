//
//  WebApiError.swift
//
//  Created by maru on 2017/09/19.
//

import Foundation

enum WebApiError: Error {    
    case connectionError(errorMessage: String)
    case responseParseError(errorMessage: String)
    
    var errorMessage: String {
        switch self {
        case .connectionError(let errorMessage):
            return errorMessage
        case .responseParseError(let errorMessage):
            return errorMessage
        }
    }
}
