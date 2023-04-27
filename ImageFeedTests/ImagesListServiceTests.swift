
import XCTest
@testable import ImageFeed

final class ImagesListServiceTests: XCTestCase {
    func testFetchPhotos() {
        let service = ImagesListService()
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: service.DidChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        guard let token = OAuth2TokenStorage.standard.token else { return }
        service.fetchPhotosNextPage(token: token) { _ in
        }
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(service.photos.count, 10)
        service.fetchPhotosNextPage(token: token) { _ in
        }
    }
}
