import SwiftUI

struct UsersView: View {
    
    @Environment(\.userEventService) private var userEvents
    @StateObject private var viewModel = UsersViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HeaderBannerView(title: LocalizeStrings.headerGetMsg)
                    .padding(.top, 1)
                if viewModel.displayedUsers.isEmpty {
                    emptyView
                } else {
                    userListView
                }
            }
        }
        .onAppear() {
            viewModel.bindUserRegistration(userEvents)
            viewModel.fetchUsers()
        }
    }
}

private extension UsersView {
    
    var userListView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(viewModel.displayedUsers.enumerated()), id: \.element.id) { index, user in
                    getUserCellView(user: user, index: index)
                }
            }
        }
        .scrollIndicators(.hidden)
        .refreshable {
            viewModel.fetchUsers()
        }
    }
    
    func getUserCellView(user: UserModel, index: Int) -> some View {
        UserListCell(user: user)
            .onAppear() {
                guard index == viewModel.displayedUsers.count - 3,
                      index != viewModel.paginationLastIndex
                else { return }
                viewModel.paginationLastIndex = index
                viewModel.fetchNextUsers()
            }
    }
    
    var loadingView: some View {
        HStack {
            Spacer()
            ProgressView()
                .frame(width: 30, height: 30, alignment: .center)
                .padding(.vertical, 30)
            Spacer()
        }
        .background(.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())
    }
    
    var emptyView: some View {
        VStack(spacing: 24) {
            Image(.noUserIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            Text(LocalizeStrings.notYetUserText)
                .font(FontName.regular.fontNunitoSansFontWeightSans(20))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .multilineTextAlignment(.center)
        .alignmentGuide(.top) { _ in 0 }
    }
}

#Preview {
    UsersView()
}
