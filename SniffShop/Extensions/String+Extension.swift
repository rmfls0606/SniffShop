//
//  String+Extension.swift
//  SniffShop
//
//  Created by 이상민 on 7/27/25.
//

import Foundation

extension String {
    var removedTagsText: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
