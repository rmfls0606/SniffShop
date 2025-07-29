//
//  ADCollectionViewCell.swift
//  SniffShop
//
//  Created by 이상민 on 7/30/25.
//

import UIKit
import SnapKit
import Kingfisher

class ADCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "ADCollectionViewCell"
    
    private let adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray4
        imageView.clipsToBounds = true
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
    
    func configureData(product: NaverShoppingResultItem){
        if let image_url = URL(string: product.image){
            adImageView.kf.setImage(with: image_url)
        }
    }
}
