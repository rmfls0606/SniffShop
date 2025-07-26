//
//  SearchResultViewController.swift
//  SniffShop
//
//  Created by 이상민 on 7/26/25.
//

import UIKit
import SnapKit

class SearchResultViewController: UIViewController {
    
    private let resultCountLabel: UILabel = {
        let label = UILabel()
        label.text = "13,235,449 개의 검색 결과"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .green
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
        configureView()
    }
}

extension SearchResultViewController: ViewDesignProtocol{
    func configureHierarchy() {
        view.addSubview(resultCountLabel)
    }
    
    func configureLayout() {
        resultCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    func configureView() {
        view.backgroundColor = .black
        
        navigationItem.title = "킁킁인형"
    }
    
    
}
