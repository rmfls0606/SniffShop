//
//  MainViewModel.swift
//  SniffShop
//
//  Created by 이상민 on 8/12/25.
//

import Foundation

final class MainViewModel{
    
    let inputProductName: Observable<String?> = Observable(nil)
    
    private(set) var outputProductName: Observable<String> = Observable("")
    private(set) var outputAlertMessage: Observable<String> = Observable("")
    
    init(){
        inputProductName.lazyBind { [weak self] _ in
            self?.productNameValidate()
        }
    }
    
    private func productNameValidate(){
        guard let text = inputProductName.value, text.trimmingCharacters(in: .whitespaces).count >= 2 else {
            outputAlertMessage.value = "정확한 검색을 위해 두 글자 이상 검색어를 입력해주세요."
            
            return
        }
        
        outputProductName.value = text
    }
}
