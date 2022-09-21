//
//  UIViewController+Alert.swift
//  TodoList
//
//  Created by Yulya Greshnova on 05.07.2022.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?,
                   message: String?,
                   actions: [UIAlertAction],
                   preferredStyle: UIAlertController.Style = .alert) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: preferredStyle)
        for action in actions {
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
    }
}
