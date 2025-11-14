
import UIKit
import SnapKit
import RxSwift

class CryptocurrencyTableViewCell: UITableViewCell {
    
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let shortNameLabel = UILabel()
    private let priceLabel = UILabel()

    
    private var oldPrice: Double?
    
    private var resetColorWorkItem: DispatchWorkItem?

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
    
    func setPriceColor(_ color: UIColor) {
        priceLabel.textColor = color
        resetColorWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            UIView.transition(with: self.priceLabel,
                              duration: 0.3,
                              options: .transitionCrossDissolve) {
                self.priceLabel.textColor = .black
            }
        }
        resetColorWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
    
    func configure(with crypto: Coin) {
        nameLabel.text = crypto.fullCoinName
        shortNameLabel.text = crypto.shortCoinName
        priceLabel.text = String(format: "$%.2f", crypto.price)
        
        disposeBag = DisposeBag()
                
        crypto.priceRelay
            .subscribe(onNext: { [weak self] newPrice in
                guard let self = self,
                      let oldPrice = crypto.oldPrice else { return }
                
                self.priceLabel.text = String(format: "$%.2f", newPrice)
                if newPrice > oldPrice {
                    self.setPriceColor(.systemGreen)
                } else if newPrice < oldPrice {
                    self.setPriceColor(.systemRed)
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
        resetColorWorkItem?.cancel()
        resetColorWorkItem = nil
        priceLabel.layer.removeAllAnimations()
        priceLabel.textColor = .black
    }
}
