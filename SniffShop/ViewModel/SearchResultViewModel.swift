//
//  SearchResultViewModel.swift
//  SniffShop
//
//  Created by 이상민 on 8/12/25.
//

import Foundation

final class SearchResultViewModel{
    var inputTitle: Observable<String> = Observable("")
    var inputSort: Observable<SortOptions> = Observable(.sim)
    var inputProductWillDisplayItem: Observable<Int> = Observable(0)
    var inputAdWillDisplayItem: Observable<Int> = Observable(0)
    
    private(set) var outputTitle: Observable<String> = Observable("")
    private(set) var outputProducts: Observable<[NaverShoppingResultItem]> = Observable([])
    private(set) var outputAds: Observable<[NaverShoppingResultItem]> = Observable([])
    private(set) var outputErrorMessage: Observable<String?> = Observable(nil)
    private(set) var outputTotalCountText: Observable<String> = Observable("0 개의 검색 결과")
    
    private var resultStart: Int = 1 //결과 시작 위치
    private var adStart: Int = 1 //광고 시작 위치
    private var totalCount: Int = 0
    private var adTotalCount: Int = 0
    private var isEnd = false
    private var adIsEnd = false
    
    init(){
        inputTitle.lazyBind { [weak self] title in
            self?.outputTitle.value = title
            self?.reset()
            
            self?.adCallRequest()
        }
        
        inputSort.lazyBind { [weak self] sort in
            self?.reset()
        }
        
        inputProductWillDisplayItem.lazyBind { [weak self] index in
            self?.productPageRequest(currentIndex: index)
        }
        
        inputAdWillDisplayItem.lazyBind { [weak self] index in
            self?.adPageRequest(currentIndex: index)
        }
    }
    
    private func reset(){
        resultStart = 1
        totalCount = 0
        isEnd = false
        outputProducts.value = []
        outputTotalCountText.value = "0 개의 검색 결과"
        shoppingCallRequest()
    }
    
    private func shoppingCallRequest(){
        NetworkManager.shared.callRequest(api: .shopping(query: inputTitle.value, sort: inputSort.value.sort, start: resultStart)) { [weak self] (value: NaverShoppingResultResponse)in
            
            guard !value.items.isEmpty else{
                self?.isEnd = true
                return
            }
            
            self?.totalCount = value.total
            self?.isEnd = self?.resultStart ?? 0 >= min(1100, self?.totalCount ?? 0)
            self?.outputTotalCountText.value = "\(NumberFormatterManager.shared.formatNumber(value.total)) 개의 검색 결과"
            
            self?.outputProducts.value += value.items
        } failureHandler: { error in
            print(error)
        }
    }
    
    private func adCallRequest(){
        NetworkManager.shared.callRequest(api: .shopping(query: "치킨", sort: inputSort.value.sort, start: adStart)) { [weak self] (value: NaverShoppingResultResponse)in
            
            guard !value.items.isEmpty else{
                self?.adIsEnd = true
                return
            }
            
            self?.adTotalCount = value.total
            self?.adIsEnd = self?.adStart ?? 0 >= min(1100, self?.adTotalCount ?? 0)
            
            self?.outputAds.value += value.items
        } failureHandler: { error in
            print(error)
        }
    }
    
    private func productPageRequest(currentIndex: Int){
        guard outputProducts.value.count > 0 else { return }
        if currentIndex >= outputProducts.value.count - 4 && !isEnd{
            self.resultStart += 100
            shoppingCallRequest()
        }
    }
    
    private func adPageRequest(currentIndex: Int){
        guard outputAds.value.count > 0 else { return }
        if currentIndex >= outputAds.value.count - 4 && !adIsEnd{
            self.adStart += 100
            adCallRequest()
        }
    }
}
