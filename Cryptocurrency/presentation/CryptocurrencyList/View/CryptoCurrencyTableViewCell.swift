
import UIKit
import SnapKit
import RxSwift

class CryptocurrencyTableViewCell: UITableViewCell {
    
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let shortNameLabel = UILabel()
    private let priceLabel = UILabel()
    
    private var oldPrice: Double?
    
    var disposeBag = DisposeBag()
    
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
    
    func defolteColor (label: UILabel) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.transition(with: label, duration: 0.5, options: .transitionCrossDissolve, animations: {
                label.textColor = .black
            })
        }
    }
    
    func configure(with crypto: Coin) {
        nameLabel.text = crypto.fullCoinName
        shortNameLabel.text = crypto.shortCoinName
        priceLabel.text = String(format: "$%.2f", crypto.price)
        
        disposeBag = DisposeBag()
        
        crypto.oldPrice
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] oldPrice in
                guard let self = self else { return }
                
                if crypto.price > oldPrice {
                    self.priceLabel.textColor = .systemGreen
                    self.defolteColor(label: self.priceLabel)
                } else if crypto.price < oldPrice {
                    self.priceLabel.textColor = .systemRed
                    self.defolteColor(label: self.priceLabel)
                } else {
                    self.priceLabel.textColor = .label
                }
            })
            .disposed(by: disposeBag)
        
        iconImageView.image = UIImage(systemName: "bitcoinsign.circle")
        
        if let url = crypto.iconURL {
            loadImage(from: url)
        }
    }

    private func loadImage(from url: URL) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.iconImageView.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
