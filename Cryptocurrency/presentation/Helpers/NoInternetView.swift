
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NoInternetView: UIView {
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let messageLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    private var disposeBag = DisposeBag()
    
    let retryTap = PublishRelay<Void>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        let containerView = UIView()
        addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        containerView.addSubview(activityIndicator)
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
        
        showLoading()
    }
    
    func setMessage(_ text: String) {
        messageLabel.text = text
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        retryButton.isEnabled = false
        retryButton.alpha = 0.5
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        retryButton.isEnabled = true
        retryButton.alpha = 1.0
    }
}

