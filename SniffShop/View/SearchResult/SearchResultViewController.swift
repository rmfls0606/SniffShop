//
//  SearchResultViewController.swift
//  SniffShop
//
//  Created by 이상민 on 7/26/25.
//

import UIKit
import SnapKit
import Alamofire

class SearchResultViewController: BaseViewController {
    
    enum SortOptions: Int, CaseIterable{
        case sim = 0, date, asc, dsc
        
        var title: String{
            switch self{
            case .sim: return "정확도"
            case .date: return "날짜순"
            case .asc: return "가격낮은순"
            case .dsc: return "가격높은순"
            }
        }
        
        var sort: String{
            switch self{
            case .sim: return "sim"
            case .date: return "date"
            case .asc: return "asc"
            case .dsc: return "dsc"
            }
        }
    }
    
    //MARK: - Property
    let productName: String
    private var productList: [NaverShoppingResultItem] = []
    private var adList: [NaverShoppingResultItem] = []
    private var sortButtons: [UIButton] = []
    private var selectedSortOption: SortOptions = .sim
    private var start: Int = 1 //시작 위치
    private var totalCount: Int = 0
    
    
    //MARK: - View
    private let resultCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 개의 검색 결과"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .green
        return label
    }()
    
    private let filterStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.alignment = .fill
        view.distribution = .fillProportionally
        return view
    }()
    
    private let collectionViewStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .fill
        view.distribution = .fill
        return view
    }()
    
    private let resultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width
        let padding = 16.0
        let spacing = 16.0
        let itemCount = 2.0
        
        let dimension = (width - (padding * 2) - (spacing * (itemCount - 1))) / itemCount
        layout.itemSize = CGSize(width: dimension, height: dimension * 1.4)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.tag = 0
        return collectionView
    }()
    
    private let adCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let dimension = UIScreen.main.bounds.width * 0.3
        
        layout.itemSize = CGSize(width: dimension, height: dimension)
        layout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.tag = 1
        return collectionView
    }()
    
    private let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        return view
    }()
    
    init(productName: String) {
        self.productName = productName
        super.init(nibName: nil, bundle: nil)
        callRequest(query: productName, sort: selectedSortOption.sort)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - BaseViewController
    override func configureHierarchy() {
        view.addSubview(resultCountLabel)
        
        view.addSubview(filterStackView)
        
        view.addSubview(collectionViewStackView)
        
        collectionViewStackView.addArrangedSubview(resultCollectionView)
        collectionViewStackView.addArrangedSubview(adCollectionView)
        
        view.addSubview(indicatorView)
    }
    
    override func configureLayout() {
        resultCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        filterStackView.snp.makeConstraints { make in
            make.top.equalTo(resultCountLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        
        collectionViewStackView.snp.makeConstraints { make in
            make.top.equalTo(filterStackView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        adCollectionView.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.width * 0.3)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        view.backgroundColor = .black
        
        navigationItem.title = productName
        
        resultCollectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        
        adCollectionView.register(ADCollectionViewCell.self, forCellWithReuseIdentifier: ADCollectionViewCell.identifier)
        adCollectionView.delegate = self
        adCollectionView.dataSource = self
        makeFilterItem()
    }
    
    
    //MARK: - function
    func makeFilterItem() {
        for (index, sortOption) in SortOptions.allCases.enumerated(){
            var config = UIButton.Configuration.plain()
            let button = UIButton()
            
            config.attributedTitle = AttributedString(sortOption.title, attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 12)
            ]))
            
            config.baseForegroundColor = .white
            
            button.configuration = config
            
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.white.cgColor
            button.clipsToBounds = true
            button.backgroundColor = .black
            button.tag = index
            
            button.addTarget(self, action: #selector(sortButtonClicked), for: .touchUpInside)
            filterStackView.addArrangedSubview(button)
            sortButtons.append(button)
        }
        
        sortButtons[0].configuration?.baseForegroundColor = .black
        sortButtons[0].backgroundColor = .white
    }
    
    @objc
    private func sortButtonClicked(_ sender: UIButton){
        guard let newOption = SortOptions(rawValue: sender.tag) else{
            return
        }
        
        let previousSortOption = selectedSortOption
        sortButtons[previousSortOption.rawValue].configuration?.baseForegroundColor = .white
        sortButtons[previousSortOption.rawValue].backgroundColor = .black
        
        selectedSortOption = newOption
        sortButtons[selectedSortOption.rawValue].configuration?.baseForegroundColor = .black
        sortButtons[selectedSortOption.rawValue].backgroundColor = .white
        
        productList.removeAll()
        start = 1
        callRequest(query: productName, sort: selectedSortOption.sort)
    }
    
    func callRequest(query: String, sort: String){
        indicatorView.startAnimating()
        NetworkManager.shared
            .callRequest(
                api: NaverRequest
                    .shopping(query: query, sort: sort, start: start)) { (value: NaverShoppingResultResponse) in
                        self.indicatorView.stopAnimating()
                        self.totalCount = value.total
                        self.productList.append(contentsOf: value.items)
                        self.resultCountLabel.text = "\(NumberFormatterManager.shared.formatNumber(value.total)) 개의 검색 결과"
                        self.resultCollectionView.reloadData()
                        
                        if self.start == 1{
                            self.resultCollectionView
                                .scrollToItem(at: IndexPath(item: 0, section: 0),
                                              at: .top,
                                              animated: true)
                        }
                    } failureHandler: { error in
                        self.indicatorView.stopAnimating()
                        
                        if let afError = error as? AFError,
                           let urlError = afError.underlyingError as? URLError,
                           urlError.code == .notConnectedToInternet{
                            self.showAlert(title: "네트워크 오류",
                                           message: "인터넷에 연결되어 있지 않습니다.\nWi-Fi 또는 셀룰러 설정으로 이동할 수 있습니다.",
                                           checkButtonTitle: "설정으로 이동",
                                           isCancelButton: true) {
                                if let url = URL(string: UIApplication.openSettingsURLString),
                                   UIApplication.shared.canOpenURL(url){
                                    UIApplication.shared.open(url)
                                }
                            }
                            return
                        }
                        
                        self.showAlert(title: "오류", message: error.localizedDescription, checkButtonTitle: "확인") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
    }
}

//MARK: - CollectionView Delegate
extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0{
            return productList.count
        }else{ //tag = 1
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier,
                                                                for: indexPath) as? SearchResultCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configureData(product: productList[indexPath.item])
            
            return cell
        }else{ //tag = 1
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ADCollectionViewCell.identifier,
                                                                for: indexPath) as? ADCollectionViewCell else{
                return UICollectionViewCell()
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == productList.count - 4 && min(totalCount, 1100) > productList.count{
            start += 30
            callRequest(query: productName, sort: selectedSortOption.sort)
        }
    }
}
