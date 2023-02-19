
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let tabBarViewController = UITabBarController()
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        let imagesListViewController = ImagesListViewController()
        imagesListViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_editorial_active"), selectedImage: nil)
        tabBarViewController.viewControllers = [profileViewController, imagesListViewController]
        tabBarViewController.selectedIndex = 1
        tabBarViewController.tabBar.barTintColor = Colors.backgroundColor
        tabBarViewController.tabBar.isTranslucent = false
        window?.rootViewController = tabBarViewController
        window?.makeKeyAndVisible()
    }
}
