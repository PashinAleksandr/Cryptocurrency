
import Foundation
import Kingfisher
import RxSwift
import RxRelay
import RxCocoa
import SnapKit

extension CryptocurrencyTableViewCell {
    class ViewModel {
        
        private let coin: Coin
        var disposeBag = DisposeBag()
        let fullName = BehaviorRelay<String>(value: "")
        let shortName = BehaviorRelay<String>(value: "")
        let price = BehaviorRelay<String>(value: "")
        let capitalization = BehaviorRelay<String>(value: "")
        let dailyChange = BehaviorRelay<Double>(value: 0)
        let iconURL = BehaviorRelay<URL?>(value: URL(fileURLWithPath: ""))
        let id = BehaviorRelay<Int>(value: 0)
        var priceCollor = BehaviorRelay<UIColor>(value: .black)
        var priceChangeDirection = BehaviorRelay<ChangingQuotes>(value: .old)

        init(coin: Coin) {
            self.coin = coin
            id.accept(coin.coinId)
            fullName.accept(coin.fullCoinName)
            shortName.accept(coin.shortCoinName)
            price.accept(String(format: "%.2f", coin.priceRelay.value))
            capitalization.accept(coin.capitalization)
            dailyChange.accept(coin.changeForDay)
            iconURL.accept(coin.iconURL)
            observePriceChanges()
        }
        
        private func observePriceChanges() {
            coin.priceRelay.skip(2).subscribe(onNext: { [weak self] newPrice in
                        guard let self else { return }

                        let old = coin.oldPrice ?? 0

                        if newPrice > old {
                            self.priceChangeDirection.accept(.up)
                        } else if newPrice < old {
                            self.priceChangeDirection.accept(.down)
                        } else {
                            self.priceChangeDirection.accept(.old)
                        }

                    })
                    .disposed(by: disposeBag)
        }
        
        func changeCoinColor(label: UILabel) -> UIColor {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                UIView.transition(with: label, duration: 3, options: .transitionCrossDissolve) {
                    label.textColor = .black
                }
            }
            return coin.priceRelay.value > coin.oldPrice ?? 0 ? .systemGreen : .systemRed
        }
    }
}


extension CryptocurrencyTableViewCell.ViewModel {
    enum ChangingQuotes {
            case up
            case down
            case old

            var color: UIColor {
                switch self {
                case .up: return .green
                case .down: return .red
                case .old: return .black
                }
            }
        }
}
