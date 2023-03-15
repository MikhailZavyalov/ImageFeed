
import Foundation

final class OAuth2Service {
    private enum NetworkError: Error {
        case codeError
        case unableToDecodeStringFromData
    }
    
    private var lastCode: String?
    private var currentTask: URLSessionDataTask?
    
    
    
    func fetchAuthToken(code: String, handler: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastCode == code { return }
        currentTask?.cancel()
        lastCode = code
        
        guard let request = makeRequest(code: code) else { return }
        
        // MARK: - Question
        currentTask = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.currentTask = nil
                if let error = error {
                    self.lastCode = nil
                    handler(.failure(error))
                    return
                }
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode >= 299 {
                    handler(.failure(NetworkError.codeError))
                    return
                }
                
                guard let data = data,
                      let oAuthToken = String(data: data, encoding: .utf8) else {
                    handler(.failure(NetworkError.unableToDecodeStringFromData))
                    return
                }
                
                //                JSONDecoder().decode(OAuthTokenResponseBody.self, from: oAuthToken.data(using: .utf8)!)
                handler(.success(oAuthToken))
            }
        }
        currentTask?.resume()
    }
    
    private func makeRequest(code: String) -> URLRequest? {
        let url = URL(string: "https://unsplash.com/oauth/token")!
        var request = URLRequest(url: url)
        let params: [String: Any] = [
            "client_id": Constants.accessKey,
            "client_secret": Constants.secretKey,
            "redirect_uri": Constants.redirectURI,
            "code": code,
            "grant_type": "authorization_code"
        ]
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
        return request
    }
}
