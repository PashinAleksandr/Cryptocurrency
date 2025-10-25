import Charts
import UIKit

class ChartPopupMarker: MarkerView {
    
    private let dateLabel = UILabel()
    private let priceLabel = UILabel()
    private let stackView = UIStackView()
    
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd MMM yyyy, HH:mm"
        return f
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.85)
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        dateLabel.font = .systemFont(ofSize: 12, weight: .medium)
        dateLabel.textColor = .white
        
        priceLabel.font = .boldSystemFont(ofSize: 14)
        priceLabel.textColor = .systemGreen
        
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(priceLabel)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(8) }
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        if let timestamp = entry.data as? TimeInterval {
            let date = Date(timeIntervalSince1970: timestamp)
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = "—"
        }
        priceLabel.text = String(format: "$%.2f", entry.y)
        
        layoutIfNeeded()
    }
    
    override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        let size = self.bounds.size
        return CGPoint(x: -size.width / 2, y: -size.height - 10)
    }
}
