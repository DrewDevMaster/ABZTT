import Foundation

struct UsersRegisterResponse: Codable {
    
    let success: Bool
    let userId: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case success, message
        case userId = "user_id"
    }
}
