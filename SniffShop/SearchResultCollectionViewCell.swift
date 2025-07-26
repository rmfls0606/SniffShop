//
//  SearchResultCollectionViewCell.swift
//  SniffShop
//
//  Created by 이상민 on 7/27/25.
//

import UIKit
import SnapKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Property
    static let identifier = "SearchResultCollectionViewCell"
    
    //MARK: - View
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .orange
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchResultCollectionViewCell: ViewDesignProtocol{
    func configureHierarchy() {
        contentView.addSubview(productImageView)
        
        contentView.addSubview(productMallName)
        
        contentView.addSubview(productTitle)
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
    }
    
    func configureView() {
        
    }
}
