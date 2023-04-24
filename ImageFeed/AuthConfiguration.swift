
import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
}

extension AuthConfiguration {
    static let standard: Self = .init(
        accessKey: Constants.accessKey,
        secretKey: Constants.secretKey,
        redirectURI: Constants.redirectURI,
        accessScope: Constants.accessScope,
        defaultBaseURL: Constants.defaultBaseURL,
        authURLString: Constants.unsplashAuthorizeURLString
    )
}

private enum Constants {
    static let accessKey = "z55xiYLhWoETxiNW1zIoOzikYek5r5pjPBS7cXHXeSY"
    static let secretKey = "gMzLHUP5yfxRAGlLNHUg7CtW7QKtt6_ISBZi-Le-bwo"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL: URL = URL(string: "https://api.unsplash.com/")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
