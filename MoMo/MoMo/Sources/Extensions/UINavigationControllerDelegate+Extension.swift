//
//  UINavigationControllerDelegate+Extension.swift
//  MoMo
//
//  Created by 초이 on 2021/02/25.
//

import UIKit

extension UINavigationController: UINavigationControllerDelegate {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    // edge pan gesture 활성화, 비활성화
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        if responds(to: #selector(getter: self.interactivePopGestureRecognizer)) {
            
            // 현재 VC가 Home, Login, teamMOMO일 때 gesture 비활성화
            if viewController.isKind(of: HomeViewController.self) || viewController.isKind(of: LoginViewController.self) || viewController.isKind(of: TeamViewController.self) {
                interactivePopGestureRecognizer?.isEnabled = false
            } else {
                interactivePopGestureRecognizer?.isEnabled = true
            }
            
            // 다이어리 작성 후 diary VC 진입 시 gesture 비활성화
            if viewControllers.count > 1 {
                
                if viewController.isKind(of: DiaryViewController.self) && viewControllers[viewControllers.count - 2].isKind(of: DeepViewController.self) {
                    interactivePopGestureRecognizer?.isEnabled = false
                } 
            } else {
                interactivePopGestureRecognizer?.isEnabled = true
            }
            
        }
    }
}
