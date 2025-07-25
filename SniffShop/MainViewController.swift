//
//  ViewController.swift
//  SniffShop
//
//  Created by 이상민 on 7/26/25.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    //MARK: - View
    private let mainSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.tintColor = .systemGray3
        searchBar.barTintColor = .black
        searchBar.searchTextField.textColor = .systemGray3
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "브랜드, 상품, 프로필, 태그 등",
                                                                             attributes: [.foregroundColor: UIColor.systemGray3])
        searchBar.searchTextField.leftView?.tintColor = .systemGray3
        return searchBar
    }()
    
    private let content: UIView = {
        let view = UIView()
        return view
    }()
    
    private let mainTextLabel: UILabel = {
        let label = UILabel()
        label.text = "킁킁쇼핑몰"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
}

extension MainViewController: ViewDesignProtocol{
    func configureHierarchy() {
        view.addSubview(mainSearchBar)
        
        view.addSubview(content)

        content.addSubview(mainTextLabel)
    }
    
    func configureLayout() {
        mainSearchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        content.snp.makeConstraints { make in
            make.top.equalTo(mainSearchBar.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
   
        mainTextLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configureView() {
        view.backgroundColor = .black
        
        navigationItem.title = "킁킁쇼핑몰"
    }
}
