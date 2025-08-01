//
//  SearchResultCollectionViewCell.swift
//  SniffShop
//
//  Created by 이상민 on 7/27/25.
//

import UIKit
import SnapKit
import Kingfisher

class SearchResultCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - Property
    static let identifier = "SearchResultCollectionViewCell"
    
    //MARK: - View
    private let productPosterBox: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        
        config.image = UIImage(systemName: "heart")
        
        config.cornerStyle = .capsule
        
        button.configuration = config
        button.tintColor = .white
        
        return button
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
    
    //MARK: - BaseView
    override func configureHierarchy() {
        contentView.addSubview(productPosterBox)
        
        productPosterBox.addSubview(productImageView)
        productPosterBox.addSubview(favoriteButton)
        
        contentView.addSubview(productMallName)
        
        contentView.addSubview(productTitle)
        
        contentView.addSubview(productPrice)
    }
    
    override func configureLayout() {
        productPosterBox.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(productImageView.snp.width)
        }
        
        productImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(productPosterBox.snp.width).multipliedBy(0.2)
            make.height.equalTo(favoriteButton.snp.width)
        }
        
        productMallName.snp.makeConstraints { make in
            make.top.equalTo(productPosterBox.snp.bottom).offset(5)
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
    
    override func configureView() { }
    
    //MARK: - function
    func configureData(product: NaverShoppingResultItem){
        
        if let image_url = URL(string: product.image){
            productImageView.kf.setImage(with: image_url)
        }
        
        productMallName.text = product.mallName
        productTitle.text = product.title.removedTagsText
        productPrice.text = NumberFormatterManager.shared.formatNumber(product.lprice)
    }
}
