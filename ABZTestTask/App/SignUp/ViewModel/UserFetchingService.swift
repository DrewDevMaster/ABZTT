import Foundation

protocol UserFetchingServiceProtocol {
    func fetchUserAndNotify(id: Int)
}

final class UserFetchingService: UserFetchingServiceProtocol {
    
    private let userEvents: UserEventServiceProtocol
    
    init(userEvents: UserEventServiceProtocol) {
        self.userEvents = userEvents
    }
    
    func fetchUserAndNotify(id: Int) {
        NetworkManager.getUsersById(id) { [weak self] response in
            self?.userEvents.notifyUserRegistered(response.user)
        } failure: { error in
            print("Failed while getUsersById with id \(id) and error: \(error.displayMessage)")
        }
    }
}
