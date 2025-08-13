//
//  MainViewModel.swift
//  SniffShop
//
//  Created by 이상민 on 8/12/25.
//

import Foundation

final class MainViewModel{
    var input: Input
    var output: Output
    
    struct Input {
        let productName: Observable<String?> = Observable(nil)
    }
    
    struct Output{
        private(set) var productName: Observable<String> = Observable("")
        private(set) var alertMessage: Observable<String> = Observable("")
    }
    
    init(){
        input = Input()
        output = Output()
        
        transform()
    }
    
    private func transform(){
        input.productName.lazyBind { [weak self] _ in
            self?.productNameValidate()
        }
    }
    
    private func productNameValidate(){
        guard let text = input.productName.value, text.trimmingCharacters(in: .whitespaces).count >= 2 else {
            output.alertMessage.value = "정확한 검색을 위해 두 글자 이상 검색어를 입력해주세요."
            
            return
        }
        
        output.productName.value = text
    }
}
