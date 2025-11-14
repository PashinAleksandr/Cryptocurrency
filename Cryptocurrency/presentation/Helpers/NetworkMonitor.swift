import Network
import RxSwift
import RxRelay

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    let isConnectedRelay = BehaviorRelay<Bool>(value: false)
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let connected = path.status == .satisfied
            self?.isConnectedRelay.accept(connected)
        }
        monitor.start(queue: queue)
    }
    
    var isConnected: Bool {
        return isConnectedRelay.value
    }
}
