
import UIKit

struct OAuthTokenResponseBody: Decodable {
    let access_token: String
    let token_type: String
    let refresh_token: String
    let scope: String
    let created_at: Int
}
