
import Foundation

class URLSessionMock: URLSessionProtocol {
    var page = 1
    
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let task = URLSessionDataTaskMock(completionHandler: completionHandler)
        task.page = page
        return task
    }
}

class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    var page = 1
    let completionHandler: @Sendable (Data?, URLResponse?, Error?) -> Void
    
    init(completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) {
        self.completionHandler = completionHandler
    }
    
    func cancel() {}
    
    func resume() {
        let data: Data
        if let mockFileURL = Bundle.main.url(forResource: "ImageListMock_\(page)", withExtension: "json") {
            data = FileManager.default.contents(atPath: mockFileURL.path)!
        } else {
            data = "[]".data(using: .utf8)!
        }
        let response = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        completionHandler(data, response, nil)
    }
}
