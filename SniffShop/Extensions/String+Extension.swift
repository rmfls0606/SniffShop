//
//  String+Extension.swift
//  SniffShop
//
//  Created by 이상민 on 7/27/25.
//

import Foundation

extension String{
    var htmlParseText: String{
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do{
            let attributed = try NSAttributedString(
                data: data,
                options: options,
                documentAttributes: nil
            )
            
            return attributed.string
        }catch{
            return self
        }
    }
}
