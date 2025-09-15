//
//  FavoritesViewController.swift
//  Cryptocurrency
//
//  Created by APashin on 11/09/2025.
//  Copyright © 2025 bigTopCampany. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, FavoritesViewInput, UITableViewDelegate, UITableViewDataSource {
    
    var output: FavoritesViewOutput?
    private let tableView = UITableView()
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewIsReady()
        title = "Избранное"
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: FavoritesViewInput
    func setupInitialState() {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Избранное \(indexPath.row + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsVC = detailsViewController()
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}
