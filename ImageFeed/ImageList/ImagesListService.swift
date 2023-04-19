
import UIKit

private let useMockData = true

final class ImagesListService {
    let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private var photosTask: URLSessionDataTaskProtocol?
    private var isReachedTheEnd: Bool = false
    
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
        guard !isReachedTheEnd else {
            return completion(.success([]))
        }
        
        let nextPage = lastLoadedPage == nil
            ? 1
            : lastLoadedPage! + 1
        print("🌈", "nextPage", nextPage)
        let request = makeImagesListRequest(token: token, page: nextPage)
        let mockSession = URLSessionMock()
        mockSession.page = nextPage
        
        let session: URLSessionProtocol = useMockData ? mockSession : URLSession.shared
        photosTask = session.objectTask(for: request) { [weak self] (result: Result<[ImagesListResultElement], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photosResult):
                let photosPage = photosResult.map {
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
                self.photos += photosPage
                self.lastLoadedPage = nextPage
                NotificationCenter.default.post(name: self.DidChangeNotification, object: nil)
                completion(.success(photosPage))
                if photosResult.isEmpty {
                    self.isReachedTheEnd = true
                }
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
