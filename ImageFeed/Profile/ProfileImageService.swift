
import UIKit

final class ProfileImageService {
    static let shared = ProfileImageService()
    private (set) var avatarURL: URL?
    private var getProfileImageTask: URLSessionDataTask?
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
        
        getProfileImageTask = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.getProfileImageTask = nil
                if let error = error {
                    self.lastProfileImageCode = nil
                    completion(.failure(error))
                    print(error)
                    return
                }
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode >= 299 {
                    completion(.failure(GetProfileImageError.profileImageCodeError))
                    print(response)
                    return
                }
                
                guard let data = data,
                      let profileImageURL = try? JSONDecoder().decode(UserResult.self, from: data) else {
                    completion(.failure(GetProfileImageError.unableToDecodeStringFromProfileImageData))
                    return
                }
                
                guard let avatarStringURL = profileImageURL.profile_image["small"],
                      let avatarURL = URL(string: avatarStringURL) else {
                    completion(.failure(GetProfileImageError.noURL))
                    return
                }
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
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
