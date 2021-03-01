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
            
            // 온보딩부터 시작하는지 검사
            if viewControllers[0].isKind(of: OnboardingViewController.self) {
                
                if viewControllers.count > 1 {
                    
                    // 분기 1 : 온보딩으로 진입했을 때
                    if viewControllers[1].isKind(of: MoodViewController.self) {
                        
                        // 분기 2 : 온보딩이 끝났을 때
                        if viewControllers.count > 6 {
                            interactivePopGestureRecognizer?.isEnabled = true
                            
                            // 분기 3 : 이메일 로그인을 한 후 홈으로 갔을 때 홈에서 로그인창으로 가는 pan gesture 비활성화
                            if viewControllers[6].isKind(of: EmailLoginViewController.self) {
                                
                                if viewControllers.count == 8 {
                                    interactivePopGestureRecognizer?.isEnabled = false
                                } else {
                                    interactivePopGestureRecognizer?.isEnabled = true
                                }
                            }
                            
                            if viewControllers.count > 7 {
                                // 분기 4 : 회원가입을 한 후 홈으로 갔을 때 홈에서 회원가입창으로 가는 pan gesture 비활성화
                                if viewControllers[7].isKind(of: JoinViewController.self) {
                                    
                                    if viewControllers.count == 9 {
                                        interactivePopGestureRecognizer?.isEnabled = false
                                    } else {
                                        interactivePopGestureRecognizer?.isEnabled = true
                                    }
                                }
                            }
                        
                        // 분기 2 : 온보딩이 진행중일 때
                        } else {
                            interactivePopGestureRecognizer?.isEnabled = false
                        }
                    
                    // 분기 1 : '이미 계정이 있어요' 버튼을 눌렀을 때
                    } else if viewControllers[1].isKind(of: LoginViewController.self) {
                        
                        if viewControllers.count > 2 {
                            interactivePopGestureRecognizer?.isEnabled = true
                            
                            // 분기 3 : 이메일 로그인을 한 후 홈으로 갔을 때 홈에서 로그인창으로 가는 pan gesture 비활성화
                            if viewControllers[2].isKind(of: EmailLoginViewController.self) {
                                
                                if viewControllers.count == 4 {
                                    interactivePopGestureRecognizer?.isEnabled = false
                                } else {
                                    interactivePopGestureRecognizer?.isEnabled = true
                                }
                            }
                            
                            if viewControllers.count > 3 {
                                // 분기 4 : 회원가입을 한 후 홈으로 갔을 때 홈에서 회원가입창으로 가는 pan gesture 비활성화
                                if viewControllers[3].isKind(of: JoinViewController.self) {
                                    
                                    if viewControllers.count == 5 {
                                        interactivePopGestureRecognizer?.isEnabled = false
                                    } else {
                                        interactivePopGestureRecognizer?.isEnabled = true
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                if viewControllers.count > 1 {
                    interactivePopGestureRecognizer?.isEnabled = true
                }
            }
        }
    }
}
