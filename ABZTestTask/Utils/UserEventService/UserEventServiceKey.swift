import SwiftUI

struct UserEventServiceKey: EnvironmentKey {
    static let defaultValue: UserEventServiceProtocol = UserEventService()
}

extension EnvironmentValues {
    var userEventService: UserEventServiceProtocol {
        get { self[UserEventServiceKey.self] }
        set { self[UserEventServiceKey.self] = newValue }
    }
}
