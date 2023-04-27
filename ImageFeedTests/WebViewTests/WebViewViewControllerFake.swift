
@testable import ImageFeed
import Foundation

class WebViewViewControllerFake: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var loadRequestWasCalled = false
    
    func viewDidLoad() {
        presenter?.viewDidLoad()
    }
    
    func load(request: URLRequest) {
        loadRequestWasCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
    }
    
    func setProgressHidden(_ isHidden: Bool) {
    }
}
