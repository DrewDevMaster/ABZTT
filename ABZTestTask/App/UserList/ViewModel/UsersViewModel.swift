import Foundation
import Combine

final class UsersViewModel: ObservableObject {
    
    @Published private(set) var displayedUsers = [UserModel]()
    @Published private var allUsers = [UserModel]()
    @Published private var manuallyAddedUsers = [UserModel]()
    
    @Published var paginationLastIndex = 0
    @Published var isLoading = false
        
    private var page = 0
    private var pagginationStep = 10
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }

    func bindUserRegistration(_ userEvents: UserEventServiceProtocol) {
        userEvents.userRegistered
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newUser in
                self?.insertNewUserLocally(newUser)
            }
            .store(in: &cancellables)
    }
    
    func fetchUsers() {
        guard !isLoading else { return }
        page = 1
        resetManuallyAddedUsers()
        getUser(isRefresh: true)
    }
    
    func fetchNextUsers() {
        guard !isLoading else { return }
        page += 1
        getUser(isRefresh: false)
    }
    
}

private extension UsersViewModel {
    
    private func setupBindings() {
        Publishers.CombineLatest($allUsers, $manuallyAddedUsers)
            .map { all, manual in
                let combined = manual + all
                let deduplicated = Dictionary(grouping: combined, by: \.id)
                    .compactMap { $0.value.first }
                let sorted = deduplicated.sorted {
                    if let reg1 = $0.registrationTimestamp, let reg2 = $1.registrationTimestamp, reg1 != reg2  {
                        return reg1 > reg2
                    } else {
                        return $0.id > $1.id
                    }
                }
                return sorted
            }
            .removeDuplicates()
            //.handleEvents(receiveOutput: { value in print("📥 получено:", value) })
            .receive(on: DispatchQueue.main)
            .assign(to: &$displayedUsers)
    }
    
    private func getUser(isRefresh: Bool) {
        isLoading = true
        NetworkManager.getUsers(page: page, count: pagginationStep) { [weak self] model in
            guard let self else { return }
            defer { self.isLoading = false }
            if isRefresh {
                self.allUsers = model.users
            } else {
                self.allUsers.append(contentsOf: model.users)
            }
        } failure: { [weak self] error in
            self?.isLoading = false
        }
    }
    
    private func insertNewUserLocally(_ user: UserModel) {
        manuallyAddedUsers.insert(user, at: 0)
    }
    
    private func resetManuallyAddedUsers() {
        manuallyAddedUsers = []
    }
}
