//
//  UITableView.swift
//  Cryptocurrency
//
//  Created by Aleksandr Pashin on 25.09.2025.
//

import UIKit

extension UITableView {
    func register(_ cellClass: UITableViewCell.Type) {
        register(cellClass.self, forCellReuseIdentifier: cellClass.identifier)
    }
}
