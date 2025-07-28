//
//  NumberFormatterManager.swift
//  SniffShop
//
//  Created by 이상민 on 7/29/25.
//

import Foundation

class NumberFormatterManager{
    static let shared = NumberFormatterManager()
    
    private let numberFormatter = NumberFormatter()
    
    private init(){
        numberFormatter.numberStyle = .decimal
    }
    
    func formatNumber(_ number: Int) -> String{
        return numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    func formatNumber(_ number: String) -> String{
        guard let intValue = Int(number) else {
            return number
        }
        return numberFormatter.string(from: NSNumber(value: intValue)) ?? number
    }
}
