//
//  SearchResultCollectionViewCell.swift
//  SniffShop
//
//  Created by 이상민 on 7/27/25.
//

import UIKit
import SnapKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    
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
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    //MARK: - Property
    static let identifier = "SearchResultCollectionViewCell"
    
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
    }
    
    func configureView() {
        
    }
}
