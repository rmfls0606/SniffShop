//
//  SearchResultViewModel.swift
//  SniffShop
//
//  Created by 이상민 on 8/12/25.
//

import Foundation

enum NetworkError: Error {
    case notConnectedToInternet
    case otherError(message: String)
    
    var title: String{
        switch self{
        case .notConnectedToInternet:
            return "네트워크 오류"
        case .otherError:
            return "오류"
        }
    }
    
    var message: String{
        switch self{
        case .notConnectedToInternet:
            return "인터넷에 연결되어 있ㅈ지 않습니다.\nWi-Fi 또는 셀룰러 설정으로 이동할 수 있습니다."
        case .otherError(let message):
            return message
        }
    }
    
    var buttonTitle: String{
        switch self{
        case .notConnectedToInternet:
            return "설정으로 이동"
        case .otherError:
            return "확인"
        }
    }
}

final class SearchResultViewModel{
    var input: Input
    var output: Output
    
    struct Input{
        var title: Observable<String> = Observable("")
        var sort: Observable<SortOptions> = Observable(.sim)
        var productWillDisplayItem: Observable<Int> = Observable(0)
        var adWillDisplayItem: Observable<Int> = Observable(0)
    }
    
    struct Output{
        private(set) var title: Observable<String> = Observable("")
        private(set) var products: Observable<[NaverShoppingResultItem]> = Observable([])
        private(set) var ads: Observable<[NaverShoppingResultItem]> = Observable([])
        private(set) var error: Observable<NetworkError?> = Observable(nil)
        private(set) var totalCountText: Observable<String> = Observable("0 개의 검색 결과")
        private(set) var selectedSort = Observable(SortOptions.sim)
    }
    
    private var resultStart: Int = 1 //결과 시작 위치
    private var adStart: Int = 1 //광고 시작 위치
    private var totalCount: Int = 0
    private var adTotalCount: Int = 0
    private var isEnd = false
    private var adIsEnd = false
    
    init(){
        input = Input()
        output = Output()
        
        input.title.lazyBind { [weak self] title in
            self?.output.title.value = title
            self?.reset()
            
            self?.adCallRequest()
        }
        
        input.sort.lazyBind { [weak self] sort in
            self?.reset()
            
            self?.output.selectedSort.value = sort
        }
        
        input.productWillDisplayItem.lazyBind { [weak self] index in
            self?.productPageRequest(currentIndex: index)
        }
        
        input.adWillDisplayItem.lazyBind { [weak self] index in
            self?.adPageRequest(currentIndex: index)
        }
    }
    
    private func reset(){
        resultStart = 1
        totalCount = 0
        isEnd = false
        output.products.value = []
        output.totalCountText.value = "0 개의 검색 결과"
        shoppingCallRequest()
    }
    
    private func shoppingCallRequest(){
        NetworkManager.shared.callRequest(api: .shopping(query: input.title.value, sort: input.sort.value.sort, start: resultStart), type: NaverShoppingResultResponse.self) { [weak self] value in
            
            guard !value.items.isEmpty else{
                self?.isEnd = true
                return
            }
            
            self?.totalCount = value.total
            self?.isEnd = self?.resultStart ?? 0 >= min(1100, self?.totalCount ?? 0)
            self?.output.totalCountText.value = "\(NumberFormatterManager.shared.formatNumber(value.total)) 개의 검색 결과"
            
            self?.output.products.value += value.items
        } failureHandler: { error in
            if let afError = error.asAFError,
               let urlError = afError.underlyingError as? URLError,
               urlError.code == .notConnectedToInternet{
                self.output.error.value = .notConnectedToInternet
                return
            }
            self.output.error.value = .otherError(message: error.localizedDescription)
        }
    }
    
    private func adCallRequest(){
        NetworkManager.shared.callRequest(api: .shopping(query: "치킨", sort: input.sort.value.sort, start: adStart), type: NaverShoppingResultResponse.self) { [weak self] value in
            
            guard !value.items.isEmpty else{
                self?.adIsEnd = true
                return
            }
            
            self?.adTotalCount = value.total
            self?.adIsEnd = self?.adStart ?? 0 >= min(1100, self?.adTotalCount ?? 0)
            
            self?.output.ads.value += value.items
        } failureHandler: { error in
            print(error)
        }
    }
    
    private func productPageRequest(currentIndex: Int){
        guard output.products.value.count > 0 else { return }
        if currentIndex >= output.products.value.count - 4 && !isEnd{
            self.resultStart += 100
            shoppingCallRequest()
        }
    }
    
    private func adPageRequest(currentIndex: Int){
        guard output.ads.value.count > 0 else { return }
        if currentIndex >= output.ads.value.count - 4 && !adIsEnd{
            self.adStart += 100
            adCallRequest()
        }
    }
}
