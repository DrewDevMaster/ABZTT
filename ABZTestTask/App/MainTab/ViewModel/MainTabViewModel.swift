import Foundation
import Kingfisher
import Combine

enum TabType: CaseIterable {
    case Users
    case SighUp
}

final class MainTabViewModel: ObservableObject {
    
    @Published var isNetworkConnected = true
    @Published var selectedTab: TabType = .Users

    private var cancellables = Set<AnyCancellable>()
    private let networkMonitor: NetworkMonitorProtocol
    
    init(networkMonitor: NetworkMonitorProtocol = NetworkMonitor()) {
        self.networkMonitor = networkMonitor
        bind()
    }
        
    private func bind() {
        networkMonitor.isConnectedPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$isNetworkConnected)
    }
}
