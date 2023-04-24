
import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {
    func testPresenterSetsTokenToNilWhenLogout() {
        //given
        let tokenStorage = OAuth2TokenStorageFake()
        tokenStorage.token = "qwerty"
        let presenter = ProfilePresenter(tokenStorage: tokenStorage)
        
        //when
        presenter.logout()
        
        //then
        XCTAssertNil(tokenStorage.token)
    }
}
