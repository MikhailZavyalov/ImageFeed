
import UIKit

final class ProfileImageService {
    static let shared = ProfileImageService()
    private (set) var avatarURL: URL?
    private var getProfileImageTask: URLSessionTask?
    private var lastProfileImageCode: String?
    let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    
    private enum GetProfileImageError: Error {
        case profileImageCodeError
        case unableToDecodeStringFromProfileImageData
        // TODO: - придумать норм название
        case noURL
    }
    
    struct UserResult: Decodable {
        let profile_image: [String: String]
    }
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<URL, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let request = makeProfileImageRequest(username, token)
        
        let session = URLSession.shared
        getProfileImageTask = session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            self.getProfileImageTask = nil
            switch result {
            case .success(let profileImageURL):
                guard let avatarStringURL = profileImageURL.profile_image["small"],
                      let avatarURL = URL(string: avatarStringURL) else {
                    completion(.failure(GetProfileImageError.noURL))
                    return
                }
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
            case .failure(_):
                completion(.failure(GetProfileImageError.unableToDecodeStringFromProfileImageData))
                self.lastProfileImageCode = nil
                return
            }
        }
        getProfileImageTask?.resume()
    }
    
    private func makeProfileImageRequest(_ username: String, _ token: String) -> URLRequest {
        var request = URLRequest(url: Constants.defaultBaseURL.appendingPathComponent("users/\(username)"))
        request.setValue("Bearer \(String(describing: token))", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
}
