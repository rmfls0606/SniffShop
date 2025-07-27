//
//  SearchResultCollectionViewCell.swift
//  SniffShop
//
//  Created by 이상민 on 7/27/25.
//

import UIKit
import SnapKit
import Kingfisher

class SearchResultCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Property
    static let identifier = "SearchResultCollectionViewCell"
    
    //MARK: - View
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let productMallName: UILabel = {
        let label = UILabel()
        label.text = "월드 캠핑카"
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private let productTitle: UILabel = {
        let label = UILabel()
        label.text = "스타리아 2층 캠핑카"
        label.textColor = .systemGray5
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    private let productPrice: UILabel = {
        let label = UILabel()
        label.text = "19000000"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(product: NaverShoppingResultItem){
        
        if let image_url = URL(string: product.image){
            productImageView.kf.setImage(with: image_url)
        }
        
        productMallName.text = product.mallName
        productTitle.text = product.title
        productPrice.text = product.lprice
    }
}

extension SearchResultCollectionViewCell: ViewDesignProtocol{
    func configureHierarchy() {
        contentView.addSubview(productImageView)
        
        contentView.addSubview(productMallName)
        
        contentView.addSubview(productTitle)
        
        contentView.addSubview(productPrice)
    }
    
    func configureLayout() {
        productImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(productImageView.snp.width)
        }
        
        productMallName.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        productTitle.snp.makeConstraints { make in
            make.top.equalTo(productMallName.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        productPrice.snp.makeConstraints { make in
            make.top.equalTo(productTitle.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func configureView() {
        
    }
}
