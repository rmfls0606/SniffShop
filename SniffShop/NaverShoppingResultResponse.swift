//
//  NaverShoppingResultResponse.swift
//  SniffShop
//
//  Created by 이상민 on 7/27/25.
//

import Foundation

struct NaverShoppingResultResponse: Decodable{
    let total: Int
    let items: [NaverShoppingResultItem]
}

struct NaverShoppingResultItem: Decodable{
    let productId: String
    let image: String
    let mallName: String
    let title: String
    let lprice: String
}
