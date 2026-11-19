//
//  SceneDelegate.swift
//  Astronomy App
//
//  Created by Ana Soares on 10/11/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let persistence = PersistenceController()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        
        let repository = ArticleRepository(context: persistence.context)
        
        let todayVC = ArticleViewController()
        todayVC.repository = repository
        todayVC.tabBarItem = UITabBarItem(title: "Article", image: UIImage(systemName: "newspaper"), tag: 0)
        
        let calendarVC = CalendarViewController()
        calendarVC.repository = repository
        calendarVC.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(systemName: "calendar"), tag: 1)
        
        let favoritesVC = FavoritesViewController()
        favoritesVC.repository = repository
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 1)

        let tabBar = UITabBarController()
        tabBar.viewControllers = [
            UINavigationController(rootViewController: calendarVC),
            UINavigationController(rootViewController: todayVC),
            UINavigationController(rootViewController: favoritesVC)
        ]
        tabBar.selectedIndex = 1
        tabBar.delegate = self

        window.rootViewController = tabBar
        window.makeKeyAndVisible()

        self.window = window
        
        Task { @MainActor in
            try? repository.cleanUp(keepingSeed: DailySeed.seed(for: Date()))
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

// SceneDelegate: no fim do arquivo
extension SceneDelegate: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {

        // a aba que está saindo ainda é a selecionada neste momento
        (tabBarController.selectedViewController as? UINavigationController)?
            .popViewController(animated: false)

        return true
    }
}
