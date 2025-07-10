import Combine

protocol UserEventServiceProtocol {
    var userRegistered: AnyPublisher<UserModel, Never> { get }
    func notifyUserRegistered(_ user: UserModel)
}

final class UserEventService: UserEventServiceProtocol {
    
    private let subject = PassthroughSubject<UserModel, Never>()
    
    var userRegistered: AnyPublisher<UserModel, Never> {
        subject.eraseToAnyPublisher()
    }
    
    func notifyUserRegistered(_ user: UserModel) {
        subject.send(user)
    }
}
