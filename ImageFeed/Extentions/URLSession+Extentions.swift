
import Foundation

extension URLSessionProtocol {
    
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        mockData: Data? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionDataTaskProtocol {
        let fulfillCompletionOnMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        if let mockData {
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: mockData)
                fulfillCompletionOnMainThread(.success(result))
            } catch {
                fulfillCompletionOnMainThread(.failure(error))
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        fulfillCompletionOnMainThread(.success(result))
                    } catch {
                        fulfillCompletionOnMainThread(.failure(error))
                    }
                } else {
                    //                    completion(.failure(makeGenericError()))
//                    fulfillCompletionOnMainThread(.failure(error!))
                    
                }
            } else if let error = error {
                fulfillCompletionOnMainThread(.failure(error))
            } else {
                //                completion(.failure(makeGenericError()))
                fulfillCompletionOnMainThread(.failure(error!))
            }
        })
        return task
    }
}
