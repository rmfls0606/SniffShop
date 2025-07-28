//
//  UIViewController+Extension.swift
//  SniffShop
//
//  Created by 이상민 on 7/29/25.
//

import UIKit

extension UIViewController{
    func showAlert(title: String?, message: String?, checkButtonTitle: String , completion: @escaping () -> Void){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let checkAction = UIAlertAction(title: checkButtonTitle, style: .default) { _ in
            completion()
        }
        
        alertVC.addAction(checkAction)
        
        present(alertVC, animated: true)
    }
}
