
import Foundation
import SwiftKeychainWrapper

protocol OAuth2TokenStorageProtocol {
    var token: String? { get set }
}

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    private let bearerTokenKey = "imageFeedBearerToken"
    static let standard = OAuth2TokenStorage()
    var token: String? {
        get {
            let token: String? = KeychainWrapper.standard.string(forKey: bearerTokenKey)
            return token
        }
        set {
            guard let newValue = newValue else {
                KeychainWrapper.standard.removeObject(forKey: bearerTokenKey)
                return
            }
            KeychainWrapper.standard.set(newValue, forKey: bearerTokenKey)
        }
    }
}
