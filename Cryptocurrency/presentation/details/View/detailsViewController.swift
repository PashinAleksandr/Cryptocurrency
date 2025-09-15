//
//  detailsViewController.swift
//  Cryptocurrency
//
//  Created by APashin on 15/09/2025.
//

import UIKit
import SnapKit

class detailsViewController: UIViewController, detailsViewInput {
    
    var output: detailsViewOutput?
    
    private let chartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chart.bar.fill") // TMP
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    private let segmentControl: UISegmentedControl = {
        let items = ["За всё время", "За год", "За месяц", "За неделю", "За день"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private let nameLabel = UILabel()
    private let buyPriceLabel = UILabel()
    private let sellPriceLabel = UILabel()
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bitcoinsign.circle")
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemOrange
        return iv
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewIsReady()
        setupUI()
    }
    
    // MARK: detailsViewInput
    func setupInitialState() { }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Детали"
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(
//            title: "Назад",
//            style: .plain,
//            target: self,
//            action: #selector(backTapped)
//        )
        
        view.addSubview(chartImageView)
        view.addSubview(segmentControl)
        view.addSubview(nameLabel)
        view.addSubview(buyPriceLabel)
        view.addSubview(sellPriceLabel)
        view.addSubview(logoImageView)
        
        // Layout
        chartImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(view.snp.height).multipliedBy(0.4)
        }
        
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(chartImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(20)
            make.leading.equalTo(logoImageView.snp.trailing).offset(12)
        }
        
        buyPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
        }
        
        sellPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(buyPriceLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        // test
        nameLabel.text = "Bitcoin"
        buyPriceLabel.text = "Цена покупки: $25,000"
        sellPriceLabel.text = "Цена продажи: $26,500"
    }
    
    @objc private func backTapped() {
//        navigationController?.popViewController(animated: true)
    }
}
