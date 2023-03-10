
import Foundation

class OAuth2TokenStorage {
   static private let bearerTokenKey = "imageFeedBearerToken"
   static var token: String? {
        get {
            UserDefaults.standard.string(forKey: bearerTokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: bearerTokenKey)
        }
    }
}
