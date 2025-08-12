//
//  SearchResultViewModel.swift
//  SniffShop
//
//  Created by 이상민 on 8/12/25.
//

import Foundation

final class SearchResultViewModel{
    var inputeTitle: Observable<String> = Observable("")
    
    private(set) var outputTitle: Observable<String> = Observable("")
    
    init(){
        inputeTitle.lazyBind { [weak self] title in
            self?.outputTitle.value = title
        }
    }
}
