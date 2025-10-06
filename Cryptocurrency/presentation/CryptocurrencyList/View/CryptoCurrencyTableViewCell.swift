//
//  CryptoCell.swift
//  Cryptocurrency
//
//  Created by Aleksandr Pashin on 19.09.2025.
//
//
//  CryptocurrencyTableViewCell.swift
//

import UIKit
import SnapKit

class CryptocurrencyTableViewCell: UITableViewCell {
    
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let shortNameLabel = UILabel()
    private let priceLabel = UILabel()
    
    private var oldPrice: Double?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupLayout()
    }
    private func setupUI() {
        selectionStyle = .none
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.cornerRadius = 20
        iconImageView.clipsToBounds = true
        
        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        shortNameLabel.font = .systemFont(ofSize: 14, weight: .regular)
        shortNameLabel.textColor = .secondaryLabel
        
        priceLabel.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    func setupLayout() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(shortNameLabel)
        contentView.addSubview(priceLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(priceLabel.snp.leading).offset(-8)
        }
        
        shortNameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalTo(nameLabel)
            make.bottom.equalToSuperview().inset(8)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(80)
        }
    }
    
    func configure(with crypto: Coin) {
        nameLabel.text = crypto.fullCoinName
        shortNameLabel.text = crypto.shortCoinName
        priceLabel.text = String(format: "$%.2f", crypto.price)
        
        if let oldPrice = oldPrice {
            if crypto.price > oldPrice {
                priceLabel.textColor = .systemGreen
            } else if crypto.price < oldPrice {
                priceLabel.textColor = .systemRed
            } else {
                priceLabel.textColor = .label
            }
        }
        oldPrice = crypto.price
        
        iconImageView.image = UIImage(systemName: "bitcoinsign.circle")
        if let url = crypto.iconURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.iconImageView.image = image
                    }
                }
            }
        }
    }
}
