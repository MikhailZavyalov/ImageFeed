
import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static private let bearerTokenKey = "imageFeedBearerToken"
    static var token: String? {
        get {
            let token: String? = KeychainWrapper.standard.string(forKey: OAuth2TokenStorage.bearerTokenKey)
            return token
        }
        set {
            let isSuccess = KeychainWrapper.standard.set(newValue!, forKey: OAuth2TokenStorage.bearerTokenKey)
        }
    }
    
    
    //    var isSuccess: String? {
    //        get {
    //            let getToken: String? = KeychainWrapper.standard.string(forKey: OAuth2TokenStorage.bearerTokenKey)
    //            return getToken
    //        }
    //        set {
    //            let setToken: String? = KeychainWrapper.standard.set(token, forKey: OAuth2TokenStorage.bearerTokenKey)
    //        }
    //    }
    
    
    //       static var token: String? {
    //            get {
    //                UserDefaults.standard.string(forKey: bearerTokenKey)
    //            }
    //            set {
    //                UserDefaults.standard.set(newValue, forKey: bearerTokenKey)
    //            }
    //        }
}
