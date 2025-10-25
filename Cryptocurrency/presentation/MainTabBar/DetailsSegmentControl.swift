import UIKit

protocol DetailsSegmentControlDelegate: AnyObject {
    func segmentControlDidTabted(didSelect: DetailsSegmentControl.Section)
}

class DetailsSegmentControl: UIStackView {
    
    weak var delegate: DetailsSegmentControlDelegate?
    var didSelect: ((Section) -> Void)?
    
    
    private let selectionView = UIView()
    private var selectionLeading: NSLayoutConstraint?
    private var selectionWidth: NSLayoutConstraint?
    private var selectedButton: UIButton?
    private(set) var sectionsCount: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        axis = .horizontal
        distribution = .fillEqually
        alignment = .fill
        spacing = 0
        
        selectionView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.18)
        selectionView.layer.masksToBounds = true
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectionView)
        sendSubviewToBack(selectionView)
    }
    
    func configure(with sections: [Section], defaultIndex: Int = 0) {
        removeAllSegments()
        sections.forEach { addSegment(title: $0.title, tag: $0.rawValue) }
        
        layoutIfNeeded()
        guard !arrangedSubviews.isEmpty else { return }
        
        let safeIndex = min(max(0, defaultIndex), arrangedSubviews.count - 1)
        guard let firstButton = arrangedSubviews[safeIndex] as? UIButton else { return }
        
        selectionLeading?.isActive = false
        selectionWidth?.isActive = false
        
        selectionLeading = selectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: firstButton.frame.minX)
        selectionWidth = selectionView.widthAnchor.constraint(equalToConstant: firstButton.frame.width)
        
        let top = selectionView.topAnchor.constraint(equalTo: self.topAnchor)
        let bottom = selectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate([selectionLeading!, selectionWidth!, top, bottom])
        
        layoutIfNeeded()
        selectionView.layer.cornerRadius = selectionView.bounds.height / 2
        select(button: firstButton, notify: false)
    }
    
    func addSegment(title: String, tag: Int) {
        let button = SegmentControlButton()
        button.tag = tag
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(segmentDidTapped(_:)), for: .touchUpInside)
        addArrangedSubview(button)
        sectionsCount += 1
    }
    
    func addarray(names: [String]) {
        names.forEach { addSegment(name: $0) }
    }
    
    func addSegment(name: String) {
        let button = SegmentControlButton()
        button.tag = sectionsCount
        button.setTitle(name, for: .normal)
        button.addTarget(self, action: #selector(segmentDidTapped(_:)), for: .touchUpInside)
        addArrangedSubview(button)
        sectionsCount += 1
    }
    
    @objc private func segmentDidTapped(_ sender: UIButton) {
        select(button: sender, notify: true)
    }
    
    private func select(button: UIButton, notify: Bool) {
        selectedButton?.isSelected = false
        button.isSelected = true
        selectedButton = button
        
        if selectionLeading == nil || selectionWidth == nil {
            selectionLeading = selectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: button.frame.minX)
            selectionWidth = selectionView.widthAnchor.constraint(equalToConstant: button.frame.width)
            let top = selectionView.topAnchor.constraint(equalTo: self.topAnchor)
            let bottom = selectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            NSLayoutConstraint.activate([selectionLeading!, selectionWidth!, top, bottom])
        }
        
        selectionLeading?.constant = button.frame.minX
        selectionWidth?.constant = button.frame.width
        
        UIView.animate(withDuration: 0.28, delay: 0, options: .curveEaseInOut) {
            self.layoutIfNeeded()
        }
        
        if notify, let section = Section(rawValue: button.tag) {
            delegate?.segmentControlDidTabted(didSelect: section)
            didSelect?(section)
        }
    }
    
    func removeAllSegments() {
        arrangedSubviews.forEach { view in
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        sectionsCount = 0
        selectedButton = nil
        selectionLeading?.isActive = false
        selectionWidth?.isActive = false
        selectionLeading = nil
        selectionWidth = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let selected = selectedButton {
            selectionLeading?.constant = selected.frame.minX
            selectionWidth?.constant = selected.frame.width
            UIView.performWithoutAnimation {
                self.layoutIfNeeded()
            }
        }
        selectionView.layer.cornerRadius = selectionView.bounds.height / 2
    }
}

private class SegmentControlButton: UIButton {
    override var isSelected: Bool {
        didSet {
            setTitleColor(isSelected ? .white : .systemBlue, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setTitleColor(.systemBlue, for: .normal)
        setTitleColor(.white, for: .selected)
        setTitleColor(.gray, for: .disabled)
        
        backgroundColor = .clear
        contentEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
}

extension DetailsSegmentControl {
    enum Section: Int, CaseIterable {
        case day
        case week
        case month
        case year
        case all
        
        var title: String {
            switch self {
            case .day:     return "Day"
            case .week:    return "Week"
            case .month:   return "Мonth"
            case .year:    return "Year"
            case .all:     return "All"
            }
        }
    }
}
