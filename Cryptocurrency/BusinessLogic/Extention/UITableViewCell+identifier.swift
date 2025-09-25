//
//  UITableViewCell+register.swift
//  Cryptocurrency
//
//  Created by Aleksandr Pashin on 25.09.2025.
//

import UIKit

extension UITableViewCell {
    
    static var identifier: String {
        String(describing: Self.self)
    }
    
    var identifier: String {
        Self.identifier
    }
}
