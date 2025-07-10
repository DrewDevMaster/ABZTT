import Foundation

extension Encodable {
    var data: Data? {
        try? JSONEncoder().encode(self)
    }
}
