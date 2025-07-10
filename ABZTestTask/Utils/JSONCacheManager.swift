import Foundation

final class JSONCacheManager {

    private let fileManager = FileManager.default
    private let cacheDirectory = "JSONCache"

    init() {
        createCacheDirectoryIfNeeded()
    }

    func save(_ type: (some Codable).Type, data: Data?) {
        guard let data else { return }
        let key = String(describing: type.self)
        guard let fileURL = cacheFileURL(for: key) else {
            return
        }
        do {
            try data.write(to: fileURL)
        } catch {
            print("Error load JSON data: \(error)")
        }
    }

    func load<M: Codable>(_ type: M.Type) -> M? {
        guard let fileURL = cacheFileURL(for: String(describing: type)),
              fileManager.fileExists(atPath: fileURL.path)
        else { return nil }
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let model = try JSONDecoder().decode(M.self, from: jsonData)
            return model
        } catch {
            print("Error load JSON data: \(error)")
            return nil
        }
    }

    func clearCacheOnLogout() {
        guard let cacheURL = try? fileManager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appendingPathComponent(cacheDirectory) else {
            print("Cache directory not found.")
            return
        }

        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: cacheURL, includingPropertiesForKeys: nil, options: [])
            for fileURL in fileURLs {
                try print(fileManager.removeItem(at: fileURL))
            }
            print("Cache successfully cleared.")
        } catch {
            print("Error clearing cache: \(error)")
        }
    }

    private func createCacheDirectoryIfNeeded() {
        do {
            let cacheURL = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let cacheDirectoryURL = cacheURL.appendingPathComponent(cacheDirectory)
            try fileManager.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating cache directory: \(error)")
        }
    }

    private func cacheFileURL(for key: String) -> URL? {
        let cacheURL = try? fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return cacheURL?.appendingPathComponent(cacheDirectory).appendingPathComponent(key + ".json")
    }
}
