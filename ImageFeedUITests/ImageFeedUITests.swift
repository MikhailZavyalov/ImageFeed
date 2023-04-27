
import XCTest
@testable import ImageFeed

private let login: String = ""
private let password: String = ""

enum AccessibilityIdentifiers {
    enum Auth {
        static let authButton = "auth.authButton"
    }
    
    enum WebView {
        static let view = "webView.view"
        static let loginButton = "webView.loginButton"
    }
    
    enum ImageList {
        static let likeButton = "imageList.likeButton"
    }
    
    enum SingleImageView {
        static let backButton = "singleImageView.backButton"
    }
    
    enum ProfileView {
        static let logoutButton = "profileView.logoutButton"
        static let alert = "Пока, пока!"
        static let alertYesButton = "Да"
    }
}

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        app.buttons[AccessibilityIdentifiers.Auth.authButton].tap()
        let webView = app.webViews[AccessibilityIdentifiers.WebView.view]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText(login)
        dismissKeyboardIfPresent()
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        webView.swipeUp()
        
        let webViewsQuery = app.webViews
        webViewsQuery.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons[AccessibilityIdentifiers.ImageList.likeButton].tap()
        cellToLike.buttons[AccessibilityIdentifiers.ImageList.likeButton].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons[AccessibilityIdentifiers.SingleImageView.backButton]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Mikhail Zavyalov"].exists)
        XCTAssertTrue(app.staticTexts["@zavyalov_mikhail"].exists)
        
        app.buttons[AccessibilityIdentifiers.ProfileView.logoutButton].tap()
        
        app.alerts[AccessibilityIdentifiers.ProfileView.alert].scrollViews.otherElements.buttons[AccessibilityIdentifiers.ProfileView.alertYesButton].tap()
    }
    
    private func dismissKeyboardIfPresent() {
        if app.keyboards.element(boundBy: 0).exists {
            if UIDevice.current.userInterfaceIdiom == .pad {
                app.keyboards.buttons["Hide keyboard"].tap()
            } else {
                app.toolbars.buttons["Done"].tap()
            }
        }
    }
}
