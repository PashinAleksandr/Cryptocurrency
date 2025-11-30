

import Foundation
import RxSwift
import RxRelay

class AppState {
    
    var isFetchCoinsInProcess: BehaviorRelay<Bool> = .init(value: false)
    
}
