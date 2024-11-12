import SwiftUI
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let api = RecipeService()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow()
        api.updateRecipes { [weak self] success in
            guard success else { fatalError("could not fetch data") }

            let menu = MenuVC()
            menu.api = self!.api
            DispatchQueue.main.async {
                self?.window?.rootViewController = UINavigationController(rootViewController: menu)
                self?.window?.makeKeyAndVisible()
            }
        }

        return true
    }
}
