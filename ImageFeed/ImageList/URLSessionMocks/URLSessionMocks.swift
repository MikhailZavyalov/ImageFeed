
import Foundation

class URLSessionMock: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return URLSessionDataTaskMock(completionHandler: completionHandler)
    }
}

class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    let completionHandler: @Sendable (Data?, URLResponse?, Error?) -> Void
    
    init(completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) {
        self.completionHandler = completionHandler
    }
    
    func cancel() {}
    
    func resume() {
        let mockFileURL = Bundle.main.url(forResource: "ImageListMock", withExtension: "json")!
        let data = FileManager.default.contents(atPath: mockFileURL.path)!
        let response = HTTPURLResponse(url: mockFileURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        completionHandler(data, response, nil)
    }
}
