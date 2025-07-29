//
//  UIViewController+Extension.swift
//  SniffShop
//
//  Created by 이상민 on 7/29/25.
//

import UIKit

extension UIViewController{
    func showAlert(title: String?, message: String?, checkButtonTitle: String, isCancelButton: Bool = false, completion: @escaping () -> Void){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let checkAction = UIAlertAction(title: checkButtonTitle, style: isCancelButton ? .destructive : .default) { _ in
            completion()
        }
        alertVC.addAction(checkAction)
        
        if isCancelButton{
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            alertVC.addAction(cancelAction)
        }
        
        present(alertVC, animated: true)
    }
}
