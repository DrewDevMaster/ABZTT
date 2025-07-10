import Foundation

enum UrlRequest: String {

    static private let baseUrl = "https://frontend-test-assignment-api.abz.agency"

    case token = "/api/v1/token"
    case users = "/api/v1/users"
    case positions = "/api/v1/positions"
    
    var fullUrl: String { "\(Self.baseUrl)\(rawValue)" }
}
