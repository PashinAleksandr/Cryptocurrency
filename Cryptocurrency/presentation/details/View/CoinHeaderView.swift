import UIKit
import SnapKit

final class CoinHeaderView: UIView {
    
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    
    init(coin: Coin) {
        super.init(frame: .zero)
        setupUI()
        configure(with: coin)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [iconImageView, nameLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .systemOrange
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .label
    }
    
    func configure(with coin: Coin) {
        nameLabel.text = coin.fullCoinName
        if let url = coin.iconURL {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.iconImageView.image = image
                    }
                }
            }
        } else {
            iconImageView.image = UIImage(systemName: "bitcoinsign.circle")
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 40)
    }
}
