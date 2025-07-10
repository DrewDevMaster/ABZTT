import Foundation

struct UserByIdResponse: Codable {
    let success: Bool
    let user: UserModel
    
    enum CodingKeys: String, CodingKey {
        case success, user
    }
}

struct UserModel: Identifiable, Codable, Equatable {
    
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let positionId: Int
    let photo: String
    let registrationTimestamp: Double?

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, position, photo
        case positionId = "position_id"
        case registrationTimestamp = "registration_timestamp"
    }
}

extension UserModel {
    static let mock = UserModel(
        id: 777,
        name: "Test Leanne West",
        email: "onie34@lubowitz.com",
        phone: "+380936050764",
        position: "Nobody",
        positionId: 2,
        photo: "https://frontend-test-assignment-api.abz.agency/images/users/5fa2a65977df010.jpeg",
        registrationTimestamp: Date().timeIntervalSince1970
    )
}
