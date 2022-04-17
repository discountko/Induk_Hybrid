//
//  APIClient.swift
//  Basic
//
//  Created by pineone on 2021/09/23.
//

import Alamofire
import Foundation
import Moya
import RxCocoa
import RxSwift

class DefaultAlamofireManager: Alamofire.Session {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 3 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 3 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}

class MultipartUploadAlamofireManager: Alamofire.Session {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 60 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 60 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

struct APIClient {
    private static let apiProvider = MoyaProvider<ServerApiProvider>(session: DefaultAlamofireManager.sharedManager, plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter), logOptions: .verbose))])
    
    private static let multipartApiProvider = MoyaProvider<ServerApiProvider>(session: MultipartUploadAlamofireManager.sharedManager, plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter), logOptions: .verbose))])
    
    private static func JSONResponseDataFormatter(_ data: Data) -> String {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? .empty
        } catch {
            return String(data: data, encoding: .utf8) ?? .empty
        }
    }

    /// silent -> retry, noneShowLoading -> 로딩바 보이냐 안보이냐
    static func request<T: Decodable>(_ api: ServerApiProvider, retry: Bool = true, noneShowLoading: Bool = false) -> Single<T> {
        #if !RELEASE
        Log.d("@@@ show network api path \(api.path), param \(api.task), method \(api.method)")
        #endif

        let request = Single<T>.create { observer in
            let observable = APIClient.apiProvider.rx
                .request(api)
                .subscribe { event in
                    switch event {
                    case .success(let response):
                        do {
                            let status = try response.map(String.self, atKeyPath: "status")
                            let status_message = try response.map(String.self, atKeyPath: "status_message")
                            let resultCode = ServerApiProvider.ResultCode(rawValue: String(response.statusCode)) ?? .test_0000000

                            Log.d("[API] >> \(api.path): status = \(status), status_message = \(status_message), resultCode = \(resultCode)")
                            

                            if resultCode == .test_200 {
                                do {
                                    if api.responseDataIsEmpty {
                                        let data = try response.map(T.self)
                                        observer(.success(data))
                                    } else {
                                        let data = try response.map(T.self, atKeyPath: "data")
                                        observer(.success(data))
                                    }
                                } catch let error as NSError {
                                    Log.e("resultCode \(resultCode) ..... but error = \(error)")
                                    if error.code == 1 || error.code == 3 {
                                        //"Failed to map data to a Decodable object."
                                        //let data = try response.map(T.self, atKeyPath: "status")
                                        let data = try response.map(T.self)
                                        observer(.success(data))
                                    }
                                }
                            } else {
                                Log.e("server error = \(api.path)")
                                Log.e("server resultCode = \(resultCode)")

                                    observer(.error(ServerApiProvider.Error.failureResponse(api: api, code: resultCode, desc: "")))
                            }
                        } catch {
                            Log.e("server error = \(api.path), \(error.localizedDescription)")
                            Log.e("server error code = \(response.statusCode)")
                            let resultCode = ServerApiProvider.ResultCode(rawValue: String((response.statusCode*10000) ?? 0000)) ?? .test_0000
                            observer(.error(ServerApiProvider.Error.failureResponse(api: api, code: resultCode, desc: .empty)))
                        }
                    case .error(let error):
                        do {
                            Log.e("server error = \(api.path)")
                            Log.e("server error = \(error)")

                            let mError = (((error as? MoyaError)?.errorUserInfo["NSUnderlyingError"] as? Alamofire.AFError)?.underlyingError as? NSError)
                            Log.e("mError.code = \(String(describing: mError?.code))")
                            
                            let resultCode = ServerApiProvider.ResultCode(rawValue: String(mError?.code ?? 0000)) ?? .test_0000
                            
                            // 리퀘스트 취소..!
                            guard let erros = api.errors else {
                                Log.e("resultCode : \(resultCode) \n 싱글톤으로 에러대응매니저 만들고 팝업 띄우기..!!")
                                return
                            }
                            
                            observer(.error(ServerApiProvider.Error.failureResponse(api: api, code: resultCode, desc: .empty)))
                        } catch {
                            Log.e("server error = \(api.path)")
                            observer(.error(error))
                        }
                    }
                }

            return Disposables.create {
                observable.dispose()
            }
        }.observeOn(MainScheduler.instance)

        return !retry ? request : request.retryWhen { $0.flatMap { _retry(api: api, error: $0) } }
    }

    private static func _retry(api: ServerApiProvider, error: Error) -> Single<()> {
        return Single.create { observer in
            var resultCode: ServerApiProvider.ResultCode = .test_0000000
            var message: String = .empty
            if let apiServerError = error as? ServerApiProvider.Error, case .failureResponse(let api, let code, let desc) = apiServerError {
                if let errors = api.errors, errors.contains(code) {
                    observer(.error(error))
                    return Disposables.create()
                }
                resultCode = code
                message = desc
            }
            Log.i("retry_resultCode = \(resultCode)")

            return Disposables.create()
        }
    }
    
    /// silent -> retry, noneShowLoading -> 로딩바 보이냐 안보이냐
    static func requestProgress<T: Decodable>(_ api: ServerApiProvider, retry: Bool = true, noneShowLoading: Bool = false) -> Single<T> {
        if !noneShowLoading {
            //LoadingService.shared.show()
        }
        #if !RELEASE
        Log.d("@@@ show network api path \(api.path), param \(api.task), method \(api.method)")
        #endif

        let request = Single<T>.create { observer in
            let observable = APIClient.multipartApiProvider.rx
                .requestWithProgress(api, callbackQueue: DispatchQueue.main)
                .subscribe { event in
                    defer {
                        if !noneShowLoading {
                            //LoadingService.shared.hide()
                        }
                    }

                    switch event {
                    case .completed:
                        Log.d("response.progress completed")

                        break
                    case .next(let response):
                        if let response = response.response {
                            do {
                                let code = try response.map(Int.self, atKeyPath: "status")
                                //let desc = try response.map(String.self, atKeyPath: "desc")
                                let resultCode = ServerApiProvider.ResultCode(rawValue: String(code).lowercased()) ?? .test_0000000

                                Log.d("[API] >> \(api.path): code = \(code), resultCode = \(resultCode)")

                                if resultCode == .test_200 {
                                    do {
                                        if api.responseDataIsEmpty {
                                            let data = try response.map(T.self)
                                            observer(.success(data))
                                        } else {
                                            let data = try response.map(T.self, atKeyPath: "data")
                                            observer(.success(data))
                                        }
                                    } catch let error as NSError {
                                        Log.e("resultCode \(resultCode) ..... but error = \(error)")
                                        if error.code == 1 || error.code == 3 { //"Failed to map data to a Decodable object."
                                            let data = try response.map(T.self, atKeyPath: "status")
                                            observer(.success(data))
                                        }
                                    }
                                } else {
                                    Log.e("server error = \(api.path)")
                                    Log.e("server resultCode = \(resultCode)")

                                    observer(.error(ServerApiProvider.Error.failureResponse(api: api, code: resultCode, desc: "")))
                                }
                            } catch {
                                Log.e("server error = \(api.path), \(error.localizedDescription)")
                                Log.e("server error code = \(response.statusCode)")
                                let resultCode = ServerApiProvider.ResultCode(rawValue: String((response.statusCode*10000) ?? 0000)) ?? .test_0000
                                observer(.error(ServerApiProvider.Error.failureResponse(api: api, code: resultCode, desc: .empty)))
                            }
                        } else {
                            Log.d("response.progress = \(response.progress)")
                        }

                    case .error(let error):
                        do {
                            Log.e("server error = \(api.path)")
                            Log.e("server error = \(error)")

                            let mError = (((error as? MoyaError)?.errorUserInfo["NSUnderlyingError"] as? Alamofire.AFError)?.underlyingError as? NSError)
                            Log.e("mError.code = \(String(describing: mError?.code))")
                            
                            let resultCode = ServerApiProvider.ResultCode(rawValue: String(mError?.code ?? 0000)) ?? .test_0000

                            observer(.error(ServerApiProvider.Error.failureResponse(api: api, code: resultCode, desc: .empty)))
                        } catch {
                            Log.e("server error = \(api.path)")
                            observer(.error(error))
                        }
                    }
                }

            return Disposables.create {
                observable.dispose()
            }
        }.observeOn(MainScheduler.instance)

        return !retry ? request : request.retryWhen { $0.flatMap { _retry(api: api, error: $0) } }
    }
}
