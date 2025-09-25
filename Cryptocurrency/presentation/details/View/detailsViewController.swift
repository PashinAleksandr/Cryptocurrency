
import Foundation
import UIKit
import RxSwift
import RxRelay
import RxCocoa
import SnapKit

class detailsViewController: UIViewController, detailsViewInput {
    
    var output: detailsViewOutput?
    var coin: Coin? {
        output?.coin
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let chartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chart.bar.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    private let segmentControl = DetailsSegmentControl()
    
    private let parametersStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewIsReady()
        segmentControl.delegate = self
    }
    
    func setupInitialState() {
        setupUI()
        setupFavoriteButton()
        
        if let coin = coin {
            setupTitleView(for: coin)
            configure(with: coin)
        }
        
        segmentControl.configure(with: DetailsSegmentControl.Section.allCases, defaultIndex: 0)
        segmentControl.didSelect = { section in
            print("selected:", section)
        }
    }
    
    private func setupFavoriteButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "star"),
            style: .plain,
            target: self,
            action: #selector(favoriteTapped)
        )
    }
    
    private func setupTitleView(for coin: Coin) {
        navigationItem.titleView = CoinHeaderView(coin: coin)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        [chartImageView, segmentControl, parametersStack].forEach {
            contentView.addSubview($0)
        }
        
        chartImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(view.snp.height).multipliedBy(0.4)
        }
        
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(chartImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        parametersStack.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configure(with coin: Coin) {
        parametersStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        // TODO: добавь пунктирную линию под каждую строку + значение прибей к правому борту
        let params: [(String, String)] = [
            ("Capitalization", coin.capitalization),
            ("Change For Day", "\(coin.changeForDay) %"),
            ("Proposal", "\(coin.proposal)"),
            ("Change Price", "\(coin.changePrice)"),
            ("Confirmation Algorithm", coin.confirmationAlgorithm),
            ("Hashing Algorithm", coin.hasingAlgorithm)
        ]
        
        params.forEach { title, value in
            let row = UIStackView()
            row.axis = .horizontal
            row.distribution = .fill
            row.alignment = .firstBaseline
            row.spacing = 8
            
            let titleLabel = UILabel()
            titleLabel.font = .boldSystemFont(ofSize: 16)
            titleLabel.textColor = .label
            titleLabel.text = title
            
            let valueLabel = UILabel()
            valueLabel.font = .systemFont(ofSize: 16)
            valueLabel.textColor = .secondaryLabel
            valueLabel.text = value
            valueLabel.textAlignment = .right
            valueLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
            
            row.addArrangedSubview(titleLabel)
            row.addArrangedSubview(valueLabel)
            
            parametersStack.addArrangedSubview(row)
            
            titleLabel.setContentHuggingPriority(.required, for: .horizontal)
            valueLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
    }
    
    @objc private func favoriteTapped() {
        output?.didToggleFavorite()
    }
    
    func updateFavoriteState(_ isFavorite: Bool) {
        let imageName = isFavorite ? "star.fill" : "star"
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: imageName)
    }
}

extension detailsViewController: DetailsSegmentControlDelegate {
    func segmentControlDidTabted(didSelect: DetailsSegmentControl.Section) {}
}
