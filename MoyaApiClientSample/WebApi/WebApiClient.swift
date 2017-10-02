//
//  WebApiClient.swift
//
//  Created by maru on 2017/09/19.
//

import UIKit
import Moya
import Result

struct WebApiClient {
    
    static var defaultStubBehavior: StubBehavior? = .never
    static var defaultEnvironment: WebApiEnvironment = .development
    
    private static func provider<T: WebApiRequestType>(api: T, stubBehavior: StubBehavior? = defaultStubBehavior) -> MoyaProvider<T> {
        var stubClosure: ((T) -> StubBehavior)? = nil
        if let behavior = stubBehavior {
            stubClosure = { (target: T) -> StubBehavior in
                return behavior
            }
        }
        
        var isDebuged = false
        #if DEBUG || ADHOC
            isDebuged = true
        #endif
        
        let networkLoggerPlugin = NetworkLoggerPlugin(verbose: isDebuged, cURL: isDebuged)
        let networkActivityPlugin = NetworkActivityPlugin { change in
            switch change {
            case .began:
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            case .ended:
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        let plugins: [PluginType] = [networkLoggerPlugin, networkActivityPlugin]
        
        if let _stubClosure = stubClosure {
            return MoyaProvider<T>(stubClosure: _stubClosure, plugins: plugins)
        }
        
        return MoyaProvider<T>(stubClosure:  { (target: T) -> StubBehavior in
            return .never
        }, plugins: plugins)
    }
    
    @discardableResult
    static func request<T: WebApiRequestType>(api: T, stubBehavior: StubBehavior? = defaultStubBehavior, completion: @escaping (Result<WebApiResponse<T.ResponseType>, WebApiError>) -> Swift.Void) -> Cancellable {
        let _provider = self.provider(api: api, stubBehavior: stubBehavior)
        return _provider.request(api)  { result in
            switch result {
            case let .success(moyaResponse):
                guard moyaResponse.data.count > 0 else {
                    DispatchQueue.main.async {
                        completion(Result.failure(.connectionError(errorMessage: "データの取得に失敗しました。")))
                    }
                    return
                }
                guard moyaResponse.statusCode == 200 else {
                    DispatchQueue.main.async {
                        completion(Result.failure(.connectionError(errorMessage: "ネットワーク接続がありません。\n通信状況をご確認ください。")))
                    }
                    return
                }
                
                let decoder: JSONDecoder = JSONDecoder()
                do {
                    let response: WebApiResponse<T.ResponseType> = try decoder.decode(WebApiResponse<T.ResponseType>.self, from: moyaResponse.data)
                    DispatchQueue.main.async {
                        completion(Result.success(response))
                    }
                } catch  {
                    NSLog("error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(Result.failure(.responseParseError(errorMessage: error.localizedDescription)))
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    completion(Result.failure(.connectionError(errorMessage: "ネットワーク接続がありません。\n通信状況をご確認ください。")))
                }
                return
            }
        }
    }
}
