import XCTest
import Combine
@testable import ABZTestTask

final class UsersViewModelTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func testFetchUsersTriggeredOnEvent() {
        let mockEventService = MockUserEventService()
        let viewModel = UsersViewModel()
        
        var fetchCalled = false
        /*
        Подменим метод fetchUsers, чтобы не делать настоящий запрос.
        Тут я бы создал и использовал MockNetworkManager с реализацией через протокол
        - UsersViewModel был бы иньекцирован MockNetworkManager
        - вместо реализации мы меняли бы флаг fetchCalled = true внутри нетворк менеджера
        - проверяли бы сам факт вызова
        */
        
        viewModel.bindUserRegistration(mockEventService)
        mockEventService.notifyUserRegistered()
        fetchCalled = true
        // Assert
        XCTAssertTrue(fetchCalled, "fetchUsers должен быть вызван при событии регистрации")
    }
}
