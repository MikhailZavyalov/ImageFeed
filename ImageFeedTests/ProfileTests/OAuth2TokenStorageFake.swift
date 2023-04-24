
import Foundation
@testable import ImageFeed

final class OAuth2TokenStorageFake: OAuth2TokenStorageProtocol {
    var token: String?
}
