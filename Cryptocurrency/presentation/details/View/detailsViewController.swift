//
//  detailsViewController.swift
//  Cryptocurrency
//
//  Created by APashin on 15/09/2025.
//  Updated by ChatGPT on 07/10/2025.
//

import UIKit
import RxSwift
import Charts
import SnapKit

class detailsViewController: UIViewController, detailsViewInput {

    var output: detailsViewOutput?
    var coin: Coin? { output?.coin }

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let segmentControl = DetailsSegmentControl()
    private let parametersStack = UIStackView()
    private let chartView = LineChartView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private let disposeBag = DisposeBag()

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
        segmentControl.didSelect = { [weak self] section in
            self?.output?.loadChart(for: section)
        }

        // загрузка по умолчанию (используем полное имя enum)
        output?.loadChart(for: DetailsSegmentControl.Section.day)
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
            $0.top.equalTo(chartView.snp.bottom).offset(12)
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

        // базовая настройка chartView (можешь подправить стили)
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.legend.enabled = false
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
            ("Confirmation Algorithm", coin.confirmationAlgorithm),
            ("Hashing Algorithm", coin.hasingAlgorithm)
        ]
        for (title, value) in params {
            let container = UIStackView()
            container.axis = .vertical
            container.spacing = 4
            let titleLabel = UILabel()
            titleLabel.font = .boldSystemFont(ofSize: 16)
            titleLabel.text = title
            let valueLabel = UILabel()
            valueLabel.font = .systemFont(ofSize: 16)
            valueLabel.textColor = .secondaryLabel
            valueLabel.text = value
            container.addArrangedSubview(titleLabel)
            container.addArrangedSubview(valueLabel)
            parametersStack.addArrangedSubview(container)
        }
    }

    @objc private func favoriteTapped() {
        output?.didToggleFavorite()
    }

    func updateFavoriteState(_ isFavorite: Bool) {
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: isFavorite ? "star.fill" : "star")
    }
}

// MARK: - DetailsSegmentControlDelegate
extension detailsViewController: DetailsSegmentControlDelegate {
    func segmentControlDidTabted(didSelect: DetailsSegmentControl.Section) {
        output?.loadChart(for: didSelect)
    }
}

// MARK: - Chart presenter updates
extension detailsViewController: UIViewInput {
    func showLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

//    func showError(_ message: String) {
//        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }

    func updateChartData(entries: [ChartDataEntry]) {
        let dataSet = LineChartDataSet(entries: entries, label: "Price USD")
        dataSet.drawCirclesEnabled = false
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 2
        dataSet.setColor(.systemBlue)

        // Создаём градиент корректно (CGGradient)
        let cgColors = [UIColor.systemBlue.withAlphaComponent(0.3).cgColor, UIColor.clear.cgColor] as CFArray
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations: [CGFloat] = [0.0, 1.0]
        if let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: locations) {
            dataSet.fill = LinearGradientFill(gradient: gradient, angle: 90.0)
            dataSet.drawFilledEnabled = true
        } else {
            dataSet.drawFilledEnabled = false
        }

        let lineData = LineChartData(dataSet: dataSet)
        chartView.data = lineData
        chartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
    }
}
