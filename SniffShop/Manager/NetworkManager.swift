//
//  NetworkManager.swift
//  SniffShop
//
//  Created by 이상민 on 7/29/25.
//

import Foundation
import Alamofire

class NetworkManager{
    static let shared = NetworkManager()
    
    private init() { }
    
    func callRequest<T: Decodable>(api: NaverRequest,
                                   type: T.Type,
                                   successHandler: @escaping (T) -> Void,
                                   failureHandler: @escaping (Error) -> Void){
        AF.request(api.endPoint,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: URLEncoding(destination: .queryString),
                   headers: api.headers,)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result{
                case .success(let value):
                    successHandler(value)
                case .failure(let error):
                    failureHandler(error)
                }
            }
    }
}
