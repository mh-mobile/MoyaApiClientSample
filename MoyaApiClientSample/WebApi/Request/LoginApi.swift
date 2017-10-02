//
//  LoginApi.swift
//
//  Created by maru on 2017/09/19.
//

import Moya
import Result

enum LoginApi {
    case endpoint(loginId: String, passwd: String)
}

// MARK - TargetType

extension LoginApi: WebApiRequestType {
    typealias ResponseType = LoginResponse
    
    var baseURL: URL {
        return URL(string: WebApiClient.defaultEnvironment.baseDomain())!
    }
    
    var path: String {
        return "/api/login.php"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        let path = Bundle.main.path(forResource: "login", ofType: "json")!
        return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.httpBody
    }
    
    var task: Task {
        var loginId: String = ""
        var passwd: String = ""
        if case .endpoint(let _loginId, let _passwd) = self {
            loginId = _loginId
            passwd = _passwd
        }
        
        return .requestParameters(parameters: [
            "login_id": loginId,
            "password": passwd], encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
    }
}

