import SwiftUI

struct MainTabView: View {
    
    @Environment(\.userEventService) private var userEvents
    
    @State private var selectedIndex = 0
    @State private var keyboardHeight: CGFloat = 0
    
    @StateObject var viewModel: MainTabViewModel
    
    init (viewModel: MainTabViewModel = MainTabViewModel()) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        if viewModel.isNetworkConnected {
            tabView
        } else {
            NoConnectionView()
        }
    }
    
    private var tabView: some View {
        TabView(selection: $viewModel.selectedTab) {
            UsersView()
                .tabItem {
                    TabBarItem(selectedTab: $viewModel.selectedTab, type: .Users)
                }
                .tag(TabType.Users)
            signUpView
                .tabItem {
                    TabBarItem(selectedTab: $viewModel.selectedTab, type: .SighUp)
                }
                .tag(TabType.SighUp)
        }
    }
    
    private var signUpView: some View {
        let service = UserFetchingService(userEvents: userEvents)
        let vm = SignUpViewModel(userFetchingService: service)
        return SignUpView(viewModel: vm)
    }
}

#Preview {
    MainTabView()
}
