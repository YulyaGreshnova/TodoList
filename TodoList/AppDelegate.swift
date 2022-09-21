//
//  AppDelegate.swift
//  TodoList
//
//  Created by Yulya Greshnova on 26.05.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        createDIContainer()
        let rootViewController = TodoItemListAssembly().buildViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func createDIContainer() {
        let dIContainer = DIContainer.shared
        dIContainer.register(type: IFileCache.self, component: FileCache())
    }
}
