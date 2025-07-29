//
//  ADCollectionViewCell.swift
//  SniffShop
//
//  Created by 이상민 on 7/30/25.
//

import UIKit
import SnapKit

class ADCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "ADCollectionViewCell"
    
    private let adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(adImageView)
    }
    
    override func configureLayout() {
        adImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        
    }
}
