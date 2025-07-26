//
//  SearchResultCollectionViewCell.swift
//  SniffShop
//
//  Created by 이상민 on 7/27/25.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    
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
       
    }
    
    func configureLayout() {
      
    }
    
    func configureView() {
        contentView.backgroundColor = .orange
    }
}
