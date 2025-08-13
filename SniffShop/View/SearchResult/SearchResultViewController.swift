//
//  SearchResultViewController.swift
//  SniffShop
//
//  Created by 이상민 on 7/26/25.
//

import UIKit
import SnapKit
import Alamofire

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

class SearchResultViewController: BaseViewController {
    //MARK: - Property
    private var sortButtons: [UIButton] = []
    private var selectedSortOption: SortOptions = .sim
    
    let viewModel = SearchResultViewModel()
    
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
        
        resultCollectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        
        adCollectionView.register(ADCollectionViewCell.self, forCellWithReuseIdentifier: ADCollectionViewCell.identifier)
        adCollectionView.delegate = self
        adCollectionView.dataSource = self
        makeFilterItem()
        setBind()
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
    
    private func setBind(){
        viewModel.output.title.bind { [weak self] title in
            self?.navigationItem.title = title
        }
        
        viewModel.output.totalCountText.bind { [weak self] text in
            self?.resultCountLabel.text = text
        }
        
        viewModel.output.products.bind { [weak self] _ in
            self?.resultCollectionView.reloadData()
        }
        
        viewModel.output.ads.bind { [weak self] _ in
            self?.adCollectionView.reloadData()
        }
        
        viewModel.output.selectedSort.bind { [weak self] selected in
            guard let self else { return }
            self.sortButtons[self.selectedSortOption.rawValue].configuration?.baseForegroundColor = .white
            self.sortButtons[self.selectedSortOption.rawValue].backgroundColor = .black
            
            self.selectedSortOption = selected
            sortButtons[selected.rawValue].configuration?.baseForegroundColor = .black
            sortButtons[selected.rawValue].backgroundColor = .white
        }
        
        viewModel.output.error.lazyBind { [weak self] error in
            guard let error = error else { return }
            
            self?.showAlert(title: error.title, message: error.message, checkButtonTitle: error.buttonTitle) {
                switch error{
                case .notConnectedToInternet:
                    if let url = URL(string: UIApplication.openSettingsURLString),
                       UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.open(url)
                    }
                case .otherError:
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @objc
    private func sortButtonClicked(_ sender: UIButton){
        guard let newOption = SortOptions(rawValue: sender.tag) else{
            return
        }
        viewModel.input.sort.value = newOption
    }
}

//MARK: - CollectionView Delegate
extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == resultCollectionView{
            return viewModel.output.products.value.count
        }else{
            return viewModel.output.ads.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == resultCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let product = viewModel.output.products.value[indexPath.item]
            cell.configureData(product: product)
            
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ADCollectionViewCell.identifier, for: indexPath) as? ADCollectionViewCell else{
                return UICollectionViewCell()
            }
            
            let product = viewModel.output.ads.value[indexPath.item]
            cell.configureData(product: product)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == resultCollectionView{
            viewModel.input.productWillDisplayItem.value = indexPath.item
        }else{
            viewModel.input.adWillDisplayItem.value = indexPath.item
        }
    }
}
