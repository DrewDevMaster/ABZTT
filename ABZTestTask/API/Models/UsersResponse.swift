import Foundation

struct UsersResponse: Codable {
    let success: Bool
    let page: Int
    let totalPages: Int
    let totalUsers: Int
    let count: Int
    let users: [UserModel]
    
    enum CodingKeys: String, CodingKey {
        case success, page, count, users
        case totalPages = "total_pages"
        case totalUsers = "total_users"
    }
}

struct PaginationLinks: Codable {
    let nextUrl: String?
    let prevUrl: String?
}
