
import UIKit

struct OAuthTokenResponseBody: Decodable {
    let access_token: String
    let token_type: String
    let refresh_token: String
    let scope: String
    let created_at: Int
}

let url = URL(string: "https://unsplash.com/oauth/token")!
var request = URLRequest(url: url)

