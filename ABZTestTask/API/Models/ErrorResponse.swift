import Foundation

struct ErrorResponse: Codable {
    let success: Bool
    let message: String
    let fails: [String: [String]]?
}
