import SwiftUI
import Combine

final class MockUserEventService: UserEventServiceProtocol {

    private let subject = PassthroughSubject<UserModel, Never>()

    var userRegistered: AnyPublisher<UserModel, Never> {
        subject.eraseToAnyPublisher()
    }
    
    func notifyUserRegistered(_ user: UserModel) {
        subject.send(user)
    }
}

#Preview {
    let mock = MockUserEventService()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        mock.notifyUserRegistered(UserModel.mock)
    }
    return UsersView()
        .environment(\.userEventService, mock)
}
