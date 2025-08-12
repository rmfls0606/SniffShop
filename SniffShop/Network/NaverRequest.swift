//
//  NaverRequest.swift
//  SniffShop
//
//  Created by 이상민 on 7/29/25.
//

import Foundation
import Alamofire

enum NaverRequest{
    case shopping(query: String, sort: String, start: Int)
    
    var baseURL: String{
        NetworkURL.naverShopping
    }
    
    var path: String{
        switch self{
        case .shopping:
            return "/v1/search/shop.json"
        }
    }
    
    var parameters: [String: Any]{
        switch self{
        case .shopping(let query, let sort, let start):
            ["query": query, "sort": sort, "start": start, "display": 30]
        }
    }
    
    var endPoint: String{
        switch self{
        case .shopping:
            return baseURL + path
        }
    }
    
    var method: HTTPMethod{
        return .get
    }
    
    var headers: HTTPHeaders{
        return ["X-Naver-Client-Id": APIKeyManager.naverClientID,
                "X-Naver-Client-Secret": APIKeyManager.naverClienSecret]
    }
}
