import Network
import RxSwift
import RxRelay
import Alamofire

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    // MARK: it doesn't work in the simulator but it works on the device. tested on 11 pro v26.1
    private var monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    let isConnectedRelay = BehaviorRelay<Bool>(value: false)
  
    private init() {
        monitor = .init(requiredInterfaceType: .wifi)
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
