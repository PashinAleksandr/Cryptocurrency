
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ActionView: UIView {
    
    private let label = UILabel()
    private let button = UIButton(type: .system)
    private let disposeBag = DisposeBag()
    
    init(viewModel: ViewModel) {
        super.init(frame: .zero)
        setupUI()
        configure(with: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(with viewModel: ViewModel) {
        label.text = viewModel.title
        button.setTitle(viewModel.buttonName, for: .normal)
        
        if let didTapped = viewModel.didTapped {
            button.rx.tap
                .bind { didTapped() }
                .disposed(by: disposeBag)
        }
    }
    
    private func setupUI() {
        addSubview(label)
        addSubview(button)
        
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        button.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension ActionView {
    struct ViewModel {
        let title: String
        let buttonName: String
        let didTapped: (() -> Void)?
    }
}
