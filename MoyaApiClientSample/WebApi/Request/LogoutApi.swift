//
//  LogoutApi.swift
//
//  Created by maru on 2017/09/19.
//


import Moya
import Result

enum LogoutApi {
    case endpoint(sessionKey: String)
}

// MARK - TargetType

extension LogoutApi: WebApiRequestType {
    typealias ResponseType = LoginResponse
    
    var baseURL: URL {
        return URL(string: WebApiClient.defaultEnvironment.baseDomain())!
    }
    
    var path: String {
        return "/api/logout.php"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        let path = Bundle.main.path(forResource: "logout", ofType: "json")!
        return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.httpBody
    }
    
    var task: Task {
        var sessionKey: String = ""
        if case .endpoint(let _sessionKey) = self {
            sessionKey = _sessionKey
        }
        return .requestParameters(parameters: ["session_key": sessionKey], encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
    }
}
