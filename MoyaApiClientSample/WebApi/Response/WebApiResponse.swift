//
//  ApiCommonResponse.swift
//
//  Created by maru on 2017/09/19.
//

import Foundation

struct WebApiResponse<ResultsResponse: Codable>: Codable {
    var status: String
    var code: String
    var message: String
    var results: ResultsResponse?
    
    private enum CodingKeys: String, CodingKey {
        case status
        case code
        case message
        case results
    }
}

