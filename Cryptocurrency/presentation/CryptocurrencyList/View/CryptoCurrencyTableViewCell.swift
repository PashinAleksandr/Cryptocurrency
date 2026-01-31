
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
    
    private func resetAnimations() {
        layer.removeAllAnimations()
        contentView.layer.removeAllAnimations()
        priceLabel.layer.removeAllAnimations()
        nameLabel.layer.removeAllAnimations()
        shortNameLabel.layer.removeAllAnimations()
        iconImageView.layer.removeAllAnimations()
        resetColorWorkItem?.cancel()
        resetColorWorkItem = nil
        priceLabel.textColor = .black
    }
    
    func configure(with viewModel: ViewModel) {
        viewModel.fullName.bind(to: nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.shortName.bind(to: shortNameLabel.rx.text).disposed(by: disposeBag)
        viewModel.price.bind(to: priceLabel.rx.text).disposed(by: disposeBag)
        viewModel.changeCoinColor(label: priceLabel)
        viewModel.priceChangeDirection.map {$0.color}.bind(to: priceLabel.rx.textColor).disposed(by: disposeBag)
        if let price = Double(viewModel.price.value) {
            priceLabel.text = String(format: "$%.2f", price)
        }
        
        
        
        if let url = viewModel.iconURL.value {
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
        resetAnimations()
        disposeBag = DisposeBag()
    }
}
