//
//  AppDelegate.swift
//  MoMo
//
//  Created by 초이 on 2020/12/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    internal var window: UIWindow?
    var navigationController: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13, *) {
            // SceneDelegate에서 UI 관련작업 처리
        }
        else {
            
            if !UserDefaults.standard.bool(forKey: "didLaunch") {
                UserDefaults.standard.set(true, forKey: "didLaunch")
                

                let onboardingStoryboard = UIStoryboard(name: Constants.Name.onboardingStoryboard, bundle: nil)
                let onboardingViewController = onboardingStoryboard.instantiateViewController(withIdentifier: Constants.Identifier.onboardingViewController)
                
                navigationController = UINavigationController(rootViewController: onboardingViewController)
            }
            else {

                let homeStoryboard = UIStoryboard(name: Constants.Name.homeStoryboard, bundle: nil)
                let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: Constants.Identifier.homeViewController)
                
                navigationController = UINavigationController(rootViewController: homeViewController)

            }
            
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

