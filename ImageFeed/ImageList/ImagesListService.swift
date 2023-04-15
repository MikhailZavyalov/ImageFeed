
import UIKit

private let useMockData = true

final class ImagesListService {
    private (set) var photos: [Photo] = []
    private var photosTask: URLSessionDataTaskProtocol?
    let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var lastLoadedPage: Int?
    
    private enum GetImagesListError: Error {
        case ImagesCodeError
        case unableToDecodeStringFromImagesData
        case noURL
    }
    
    struct Photo {
        let id: String
        let size: CGSize
        let createdAt: Date
        let welcomeDescription: String?
        let thumbImageURL: URL
        let largeImageURL: URL
        let isLiked: Bool
    }
    
    func fetchPhotosNextPage(token: String, _ completion: @escaping (Result<[Photo], Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let nextPage = lastLoadedPage == nil
            ? 1
            : lastLoadedPage! + 1
        print("🌈", nextPage)
        let request = makeImagesListRequest(token: token, page: nextPage)
        
        let session: URLSessionProtocol = useMockData ? URLSessionMock() : URLSession.shared
        photosTask = session.objectTask(for: request) { [weak self] (result: Result<[ImagesListResultElement], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photosResult):
                self.photos = photosResult.map {
                    Photo(
                        id: $0.id,
                        size: CGSize(width: $0.width, height: $0.height),
                        createdAt: $0.createdAt,
                        welcomeDescription: $0.description,
                        thumbImageURL: $0.urls.thumb,
                        largeImageURL: $0.urls.full,
                        isLiked: $0.likedByUser
                    )
                }
                self.lastLoadedPage = nextPage
                NotificationCenter.default.post(name: self.DidChangeNotification, object: nil)
                completion(.success(self.photos))
            case .failure(let error):
                completion(.failure(GetImagesListError.unableToDecodeStringFromImagesData))
                return
            }
        }
        photosTask?.resume()
    }
    
    private func makeImagesListRequest(token: String, page: Int) -> URLRequest {
        let params = [URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "per_page", value: "10")]
        var urlComps = URLComponents(string: "https://api.unsplash.com/photos")!
        urlComps.queryItems = params
        let result = urlComps.url!
        var request = URLRequest(url: result)
        request.setValue("Bearer \(String(describing: token))", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
}
