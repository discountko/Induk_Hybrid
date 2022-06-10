//
//  ServerApiProvider.swift
//  Basic
//
//  Created by pineone on 2021/09/02.
//

import Foundation
import Moya

typealias StatLogParam = (opcode: String?,
                          req_dt: String,
                          extra: String?,
                          extra2: String?,
                          extra3: String?,
                          spend_time: String?)

enum ServerApiProvider {
    case movie_list(limit: Int?,
                    page: Int?,
                    minimum_rating: Int?)
}

extension ServerApiProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://yts.torrentbay.to/api/v2")!
    }

    var path: String {
        switch self {
        case .movie_list:           return "/list_movies.json"
        }
    }
    
    var method: Moya.Method {
        switch self {
//        case .member_sns_delete: return .delete
//        case return //.put // Modify 수정 //.post // Request 생성
        default: return .get // 가져오기
            
        }
    }
    
    // Multipart upload
    var responseDataIsEmpty: Bool {
        switch self {
//        case .uploadImage:
//            return true
        default: return false
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    // Multipart Task
    var task: Task {
        switch self {
//        case .test:
//            return .uploadCompositeMultipart(<#T##[MultipartFormData]#>, urlParameters: <#T##[String : Any]#>)
        default:
            let param: [String: Any] = objectMapper(self)
            return .requestParameters(parameters: param, encoding: parameterEncodingForMethod())
        }
    }
    
    func parameterEncodingForMethod() -> ParameterEncoding {
        switch self.method {
        case .get, .delete: return URLEncoding.default
        default: return JSONEncoding.default
        }
    }
    
    func objectMapper(_ provider: ServerApiProvider) -> [String: Any] {
        var param: [String: Any] = [:]
        let mirror = Mirror(reflecting: provider)

        for case let (_, api) in mirror.children {
            let task = Mirror(reflecting: api)
            for case let (key?, value) in task.children {
                if let v = value as? String {
                    param.updateValue(v, forKey: key)
                } else if let v = value as? Int {
                    param.updateValue(v, forKey: key)
                } else if let v = value as? Bool {
                    param.updateValue(v, forKey: key)
                } else if let v = value as? [String] {
                    param.updateValue(v, forKey: key)
                } else if let v = value as? [Int] {
                    param.updateValue(v, forKey: key)
                } /* else if let v = value as? UserLogin {
                    if let param1 = try? JSON(data: JSONEncoder().encode(v)).dictionaryObject {
                        param.updateValue(param1, forKey: key)
                    }

                } else if let v = value as? [AgreeTermsListLogin] {
                    var array: [[String: Any]] = []
                    _ = v.map {
                        if let param = try? JSON(data: JSONEncoder().encode($0)).dictionaryObject {
                            array.append(param)
                        }
                    }
                    param.updateValue(array, forKey: key)
                } */
            }
        }
        return param
    }
    
    var headers: [String : String]? {
//        var header = [
//            "Key":        "Value"
//        ]
//
//        Log.d("Header = \(header)")
        return .none //header
    }
    /// 각각의 상황에 따른 에러케이스 추가
    var errors: Set<ServerApiProvider.ResultCode>? {
        switch self {
        default: return nil
        }
    }
}

//  MARK:- 에러정의
extension ServerApiProvider {
    enum Error: Swift.Error {
        case serverMaintenance(message: String)
        // 비정상 응답 (오류코드)
        case failureResponse(api: ServerApiProvider, code: ServerApiProvider.ResultCode, desc: String)
        // 잘못된 응답 데이터 (발생시 서버 문의)
        case invalidResponseData(api: ServerApiProvider)
    }
    
    enum ResultCode: String {
        case test_0000 = "0000" // 네트워크단 레벨 에러
        case test_0000000 = "0000000" // 기타 에러.
        
        /// 성공
        case test_200 = "200" // 성공
        
        /// 실패
        case test_201 = "201" // 동의 거절
        case test_400 = "400" // 실패
        
        /// 네트워크 에러 정의.
        case network_m1000 = "-1000"
    }
}










