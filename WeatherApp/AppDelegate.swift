//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Ayush Gupta on 06/06/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = CityListViewController(nibName: "CityListViewController", bundle: nil)
        let rootVC = UINavigationController(rootViewController: vc)
        rootVC.isNavigationBarHidden = false
        rootVC.navigationBar.prefersLargeTitles = false
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
