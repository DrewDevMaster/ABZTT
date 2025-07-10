import SwiftUI
import Network
import Combine

// Протокол для Dependency Injection
protocol NetworkMonitorProtocol {
    var isConnectedPublisher: AnyPublisher<Bool, Never> { get }
}

final class NetworkMonitor: NetworkMonitorProtocol {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "DrewQueue")
    
    private let subject = CurrentValueSubject<Bool, Never>(true)
    
    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        subject.eraseToAnyPublisher()
    }
    
    init() {
        setup()
        monitor.start(queue: queue)
    }
    
    private func setup() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            let isConnected = path.status == .satisfied
            
            // Не пушим лишний раз, только если поменялось значение
            if self.subject.value != isConnected {
                self.subject.send(isConnected)
            }
        }
    }
    
    deinit {
        monitor.cancel()
    }
}

// MARK: Testable and mockable

private final class MockNetworkMonitor: NetworkMonitorProtocol {
    let subject = CurrentValueSubject<Bool, Never>(true)
    
    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        subject.eraseToAnyPublisher()
    }
}

#Preview {
    let mock = MockNetworkMonitor()
    let vm = MainTabViewModel(networkMonitor: mock)
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        let isConnected = false
        mock.subject.send(isConnected)
    }
    return MainTabView(viewModel: vm)
}
