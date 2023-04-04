
import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let oAuth2Service = OAuth2Service()
    private let ShowAuthenticationScreenSegueIdentifier = "AuthenticationScreenSegueIdentifier"
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = OAuth2TokenStorage.token {
            UIBlockingProgressHUD.show()
            profileService.fetchProfile(token) { [weak self] _ in
                guard let self else { return }
                self.profileImageService.fetchProfileImageURL(
                    token: token,
                    username: self.profileService.currentProfile!.username
                ) { _ in
                    self.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                }
            }
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    // MARK: - Question for Yandex
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assert(false)
            assertionFailure("Invalid Configuration")
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { assert(false)
                assertionFailure("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)")
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - Question
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                OAuth2TokenStorage.token = token
                self.profileService.fetchProfile(token) { _ in
                    self.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
            }
        }
    }
}

// MARK: - Alert
extension SplashViewController {
    func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
        let uiAlertAction = UIAlertAction(title: "Ok", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(uiAlertAction)
        present(alert, animated: true)
    }
}
