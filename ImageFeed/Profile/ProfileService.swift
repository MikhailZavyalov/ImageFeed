
import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    private(set) var currentProfile: Profile?
    
    private var lastProfileCode: String?
    private var getProfileTask: URLSessionDataTask?
    
    
    private enum GetProfileError: Error {
        case profileCodeError
        case unableToDecodeStringFromProfileData
    }
    
    struct Profile {
        let username: String
        let name: String
        let loginName: String
        let bio: String
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastProfileCode == token { return }
        getProfileTask?.cancel()
        lastProfileCode = token
        
        let request = makeProfileRequest(token)
        
        getProfileTask = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.getProfileTask = nil
                if let error = error {
                    self.lastProfileCode = nil
                    completion(.failure(error))
                    return
                }
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode >= 299 {
                    completion(.failure(GetProfileError.profileCodeError))
                    return
                }
                
                guard let data = data,
                      let profileResult = try? JSONDecoder().decode(ProfileResult.self, from: data) else {
                    completion(.failure(GetProfileError.unableToDecodeStringFromProfileData))
                    return
                }
                
                let profile = Profile(
                    username: profileResult.username,
                    name: profileResult.first_name + " " + profileResult.last_name,
                    loginName: "@" + profileResult.username,
                    bio: profileResult.bio ?? ""
                )
                
                self.currentProfile = profile
                completion(.success(profile))
            }
        }
        getProfileTask?.resume()
    }
    
    private func makeProfileRequest(_ token: String) -> URLRequest {
        var request = URLRequest(url: Constants.defaultBaseURL.appendingPathComponent("me"))
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
}
