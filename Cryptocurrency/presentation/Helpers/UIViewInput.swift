//
//  UIViewInput.swift
//  Cryptocurrency
//
//  Created by Aleksandr Pashin on 07.09.2025.
//

import Foundation
import UIKit

protocol UIViewInput: AnyObject {
    func show(_ error: Error)
    func showAllert(title: String, message: String)
}

extension UIViewInput {
    func show(_ error: Error) {
        showAllert(title: "Error", message: error.localizedDescription)
    }
    
    func showAllert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true)
    }
}
