//
//  NoInternetViewController.swift
//  Cryptocurrency
//
//  Created by Aleksandr Pashin on 25.09.2025.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NoInternetViewController: UIViewController {
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let messageLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    private var disposeBag = DisposeBag()
    let retryTap = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        let containerView = UIView()
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        containerView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        messageLabel.text = "Нет интернета"
        messageLabel.textAlignment = .center
        messageLabel.font = .boldSystemFont(ofSize: 18)
        
        containerView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(activityIndicator.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        retryButton.setTitle("Переподключиться", for: .normal)
        retryButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        containerView.addSubview(retryButton)
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        retryButton.rx.tap
            .bind(to: retryTap)
            .disposed(by: disposeBag)
    }
}

