
import UIKit
import RxSwift
import Charts
import SnapKit

class DetailsViewController: UIViewController, DetailsViewInput {
    
    var output: DetailsViewOutput?
    var coin: Coin? { output?.coin }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let segmentControl = DetailsSegmentControl()
    private let parametersStack = UIStackView()
    private let chartView = CandleStickChartView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var currentSection: DetailsSegmentControl.Section = .day
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewIsReady()
        segmentControl.delegate = self
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = false
    }
    
    func setupInitialState() {
        setupUI()
        setupFavoriteButton()
        
        if let coin = coin {
            setupTitleView(for: coin)
            configure(with: coin)
        }
        
        segmentControl.configure(with: DetailsSegmentControl.Section.allCases, defaultIndex: 0)
        output?.loadChart(for: .day)
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
        scrollView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        parametersStack.axis = .vertical
        parametersStack.spacing = 8
        
        [chartView, segmentControl, parametersStack, activityIndicator].forEach {
            contentView.addSubview($0)
        }
        
        chartView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(view.snp.height).multipliedBy(0.4)
        }
        

        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(chartView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        parametersStack.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalTo(chartView)
        }
        
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = true
        chartView.xAxis.labelPosition = .bottom
        chartView.legend.enabled = false
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        chartView.doubleTapToZoomEnabled = true
        chartView.dragEnabled = true
        chartView.highlightPerTapEnabled = true
    }
    
    func configure(with coin: Coin) {
        parametersStack.arrangedSubviews.forEach {
            parametersStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        let params: [(String, String)] = [
            ("Capitalization", coin.capitalization),
            ("Change For Day", "\(coin.changeForDay) %"),
            ("Proposal", "\(coin.proposal)"),
            ("Change Price", "\(coin.changePrice)"),
            ("Hashing Algorithm", coin.hasingAlgorithm)
            
        ]
        
        for (title, value) in params {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fill
            rowStack.alignment = .center
            rowStack.spacing = 8
            
            let titleLabel = UILabel()
            titleLabel.font = .boldSystemFont(ofSize: 16)
            titleLabel.textColor = .label
            titleLabel.text = title
            titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            
            let valueLabel = UILabel()
            valueLabel.font = .systemFont(ofSize: 16)
            valueLabel.textColor = .secondaryLabel
            valueLabel.text = value
            valueLabel.textAlignment = .right
            valueLabel.numberOfLines = 1
            valueLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
            
            rowStack.addArrangedSubview(titleLabel)
            rowStack.addArrangedSubview(valueLabel)
            
            let separator = UIView()
            separator.backgroundColor = .separator
            separator.snp.makeConstraints { $0.height.equalTo(1) }
            
            let container = UIStackView(arrangedSubviews: [rowStack, separator])
            container.axis = .vertical
            container.spacing = 4
            
            parametersStack.addArrangedSubview(container)
        }
    }
    
    @objc private func favoriteTapped() {
        output?.didToggleFavorite()
    }
    
    func updateFavoriteState(_ isFavorite: Bool) {
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: isFavorite ? "star.fill" : "star")
    }
    
    func showLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func updateChartData(entries: [Charts.ChartDataEntry], chartStep: Int) {
        
        let dataSet = CandleChartDataSet(entries: entries, label: "Price USD")
        
        dataSet.increasingColor = .systemGreen
        dataSet.decreasingColor = .systemRed
        dataSet.neutralColor = .gray
        
        dataSet.increasingFilled = false
        dataSet.decreasingFilled = false
        
        dataSet.shadowColorSameAsCandle = true
        dataSet.shadowWidth = 1.0
        
        dataSet.barSpace = 0.3
        dataSet.drawValuesEnabled = false
        dataSet.drawIconsEnabled = false
        
        dataSet.increasingColor = UIColor.systemGreen.withAlphaComponent(0.9)
        dataSet.decreasingColor = UIColor.systemRed.withAlphaComponent(0.9)
        
        let data = CandleChartData(dataSet: dataSet)
        chartView.data = data
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.labelTextColor = .secondaryLabel
        xAxis.labelRotationAngle = -45
        xAxis.valueFormatter = self
        xAxis.granularity = 1
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelTextColor = .label
        leftAxis.axisLineColor = .secondaryLabel
        leftAxis.drawGridLinesEnabled = true
        leftAxis.gridColor = .quaternaryLabel
        
        leftAxis.valueFormatter = DefaultAxisValueFormatter(block: { (value, _) -> String in
            if value >= 1_000_000 {
                return String(format: "%.1fM", value / 1_000_000)
            } else if value >= 1_000 {
                return String(format: "%.0fK", value / 1_000)
            } else {
                return String(format: "%.0f", value)
            }
        })
        
        if chartView.superview?.viewWithTag(1001) == nil {
            let yLabel = UILabel()
            yLabel.text = "USD"
            yLabel.font = .systemFont(ofSize: 10, weight: .medium)
            yLabel.textColor = .secondaryLabel
            yLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            yLabel.tag = 1001
            chartView.addSubview(yLabel)
            yLabel.snp.makeConstraints {
                $0.leading.equalTo(chartView.snp.leading).offset(4)
                $0.top.equalTo(chartView)
            }
        }
        let marker = ChartMarker()
        marker.chartView = chartView
        chartView.marker = marker
        chartView.animate(xAxisDuration: 1.0, easingOption: .easeInOutQuart)
        view.layoutSubviews()
    }
}

extension DetailsViewController: DetailsSegmentControlDelegate {
    func segmentControlDidTabted(didSelect section: DetailsSegmentControl.Section) {
        currentSection = section
        output?.loadChart(for: section)
        view.layoutSubviews()
    }
}

extension DetailsViewController: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        switch currentSection {
        case .day:
            formatter.dateFormat = "HH:mm"
        case .week:
            formatter.dateFormat = "dd MMM"
        case .month:
            formatter.dateFormat = "dd MMM"
        case .year:
            formatter.dateFormat = "MMM"
        case .all:
            formatter.dateFormat = "yyyy"
        }
        return formatter.string(from: date)
    }
}
