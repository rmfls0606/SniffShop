//
//  SearchResultViewController.swift
//  SniffShop
//
//  Created by 이상민 on 7/26/25.
//

import UIKit
import SnapKit
import Alamofire

class SearchResultViewController: UIViewController {
    
    //MARK: - Property
    let productName: String
    private var productList: [NaverShoppingResultItem] = []
    private let sortItem: [String] = ["정확도", "날짜순", "가격높은순", "가격낮은순"]
    private var sortButtons: [UIButton] = []
    
    //MARK: - View
    private let resultCountLabel: UILabel = {
        let label = UILabel()
        label.text = "13,235,449 개의 검색 결과"
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
        
        return collectionView
    }()
    
    init(productName: String) {
        self.productName = productName
        super.init(nibName: nil, bundle: nil)
        callRequest(query: productName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureView()
        makeFilterItem()
    }
    
    func makeFilterItem() {
        for item in sortItem{
            var config = UIButton.Configuration.plain()
            let button = UIButton()
            
            config.attributedTitle = AttributedString(item, attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 12)
            ]))
            
            config.baseForegroundColor = .white
            
            button.configuration = config
            
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.white.cgColor
            button.clipsToBounds = true
            button.backgroundColor = .black
            
            filterStackView.addArrangedSubview(button)
            sortButtons.append(button)
        }
        
        sortButtons[0].configuration?.baseForegroundColor = .black
        sortButtons[0].backgroundColor = .white
    }
    
    func callRequest(query: String){
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=100"
        
        let headers = HTTPHeaders(
            ["X-Naver-Client-Id": APIKeyManager.naverClientID,
             "X-Naver-Client-Secret": APIKeyManager.naverClienSecret]
        )
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: NaverShoppingResultResponse.self) { [weak self] response in
                switch response.result{
                case .success(let value):
                    self?.productList = value.items
                    self?.resultCountLabel.text = "\(value.total) 개의 검색 결과"
                    self?.resultCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
}

//MARK: - ViewDesignProtocol
extension SearchResultViewController: ViewDesignProtocol{
    func configureHierarchy() {
        view.addSubview(resultCountLabel)
        
        view.addSubview(filterStackView)
        
        view.addSubview(resultCollectionView)
    }
    
    func configureLayout() {
        resultCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        filterStackView.snp.makeConstraints { make in
            make.top.equalTo(resultCountLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        
        resultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterStackView.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func configureView() {
        view.backgroundColor = .black
        navigationItem.title = productName
        
        resultCollectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
    }
}

//MARK: - CollectionView Delegate
extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier,
                                                            for: indexPath) as? SearchResultCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureData(product: productList[indexPath.item])
        
        return cell
    }
}
