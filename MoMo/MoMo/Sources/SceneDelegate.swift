//
//  SceneDelegate.swift
//  MoMo
//
//  Created by 초이 on 2020/12/28.
//

import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        self.updateRootToSplashViewController()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(1500)) {
            if !self.didLaunched() {
                UserDefaults.standard.set(true, forKey: "didLaunch")
                // 로그인 여부 판단
                UserDefaults.standard.set(false, forKey: "didLogin")
                self.updateRootToOnboadingViewController()
            } else {
                if self.hasUserIdAndToken() {
                    if self.isLocked() {
                        self.updateRootToLockViewController(usage: .verifying)
                    } else {
                        self.updateRootToHomeViewController()
                    }
                } else {
                    self.updateRootToLoginViewController()
                }
            }
            self.window?.rootViewController = self.navigationController
            self.window?.makeKeyAndVisible()
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    private func updateRootToSplashViewController() {
        let splashStoryboard = UIStoryboard(name: Constants.Name.splashStoryboard, bundle: nil)
        let splashViewController = splashStoryboard.instantiateViewController(withIdentifier: Constants.Identifier.splashViewController)
        self.window?.rootViewController = splashViewController
        self.window?.makeKeyAndVisible()
    }
    
    private func updateRootToOnboadingViewController() {
        let onboardingStoryboard = UIStoryboard(name: Constants.Name.onboardingStoryboard, bundle: nil)
        let onboardingViewController = onboardingStoryboard.instantiateViewController(withIdentifier: Constants.Identifier.onboardingViewController)
        self.navigationController = UINavigationController(rootViewController: onboardingViewController)
    }
    
    private func updateRootToLockViewController(usage: LockViewUsage) {
        let lockStoryboard = UIStoryboard(name: Constants.Name.lockStoryboard, bundle: nil)
        guard let lockViewController = lockStoryboard.instantiateViewController(withIdentifier: Constants.Identifier.lockViewController) as? LockViewController else { return }
        lockViewController.lockViewUsage = usage
        self.navigationController = UINavigationController(rootViewController: lockViewController)
    }
    
    private func updateRootToHomeViewController() {
        let homeStoryboard = UIStoryboard(name: Constants.Name.homeStoryboard, bundle: nil)
        let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: Constants.Identifier.homeViewController)
        self.navigationController = UINavigationController(rootViewController: homeViewController)
    }
    
    private func updateRootToLoginViewController() {
        let loginStoryboard = UIStoryboard(name: Constants.Name.loginStoryboard, bundle: nil)
        let loginViewController = loginStoryboard.instantiateViewController(withIdentifier: Constants.Identifier.loginViewController)
        self.navigationController = UINavigationController(rootViewController: loginViewController)
    }
    
    private func pushToLockViewController(usage: LockViewUsage) {
        let lockStoryboard = UIStoryboard(name: Constants.Name.lockStoryboard, bundle: nil)
        guard let lockViewController = lockStoryboard.instantiateViewController(withIdentifier: Constants.Identifier.lockViewController) as? LockViewController else { return }
        lockViewController.lockViewUsage = usage
        self.navigationController?.pushViewController(lockViewController, animated: false)
    }
    
    private func didLaunched() -> Bool {
        return UserDefaults.standard.bool(forKey: "didLaunch")
    }
    
    private func hasUserIdAndToken() -> Bool {
        return UserDefaults.standard.object(forKey: "token") != nil && UserDefaults.standard.object(forKey: "userId") != nil
    }
    
    private func isLocked() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLocked")
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
        if let lastViewController = self.navigationController?.viewControllers.last {
            if lastViewController is DiaryViewController {
                guard let diaryViewController = lastViewController as? DiaryViewController else { return }
                diaryViewController.addBlurEffectOnBlurView()
            } else if lastViewController is DeepViewController {
                guard let deepViewController = lastViewController as? DeepViewController else { return }
                deepViewController.addBlurEffectOnBlurView()
            }
        }
        
        if self.isLocked() {
            self.pushToLockViewController(usage: .verifying)
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        if let lastViewController = self.navigationController?.viewControllers.last {
            if lastViewController is DiaryViewController {
                guard let diaryViewController = lastViewController as? DiaryViewController else { return }
                diaryViewController.removeBlurEffectOnBlurView()
            } else if lastViewController is DeepViewController {
                guard let deepViewController = lastViewController as? DeepViewController else { return }
                deepViewController.removeBlurEffectOnBlurView()
            }
        }
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

