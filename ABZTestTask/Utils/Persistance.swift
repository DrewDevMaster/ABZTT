import Foundation

let Persistance = PersistanceManager.shared

final class PersistanceManager {
    
    static let shared = PersistanceManager()
    private let defaults = UserDefaults.standard
    
    private let KLanguageCode = "Persistance.KLanguageCode"
    private let kToken = "Persistance.kToken"
    private let kAvatarUrlStrings = "Persistance.avatarUrlStrings"
    
    var languageCode: String? {
        get { defaults.string(forKey: KLanguageCode) }
        set { setValue(newValue, withKey: KLanguageCode) }
    }
 
    var token: String? {
        get { defaults.string(forKey: kToken) }
        set { setValue(newValue, withKey: kToken) }
    }
    
    var avatarUrlStrings: Set<String> {
        get {
            if let array = defaults.stringArray(forKey: kAvatarUrlStrings) {
                return Set(array)
            }
            return Set()
        }
        set { setValue(Array(newValue), withKey: kAvatarUrlStrings) }
    }
}

extension PersistanceManager {
    private func setValue<T>(_ value: T, withKey key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    func clearAllUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
    }
    
    func removeForKey(_ key: String) {
        defaults.removeObject(forKey: key)
    }
}
