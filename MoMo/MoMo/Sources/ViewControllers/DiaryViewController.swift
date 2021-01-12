//
//  DiaryViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/12.
//

import UIKit

class DiaryViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moodImage: UIImageView!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var depthImage: UIImageView!
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var diaryLabel: UILabel!
    
    @IBOutlet weak var blurView: UIView!
    
    var currentDepth: Depth?
    var menuView: MenuView?
    var menuToggleFlag: Bool = false
    
    lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "icSubtab"), style: .done, target: self, action: #selector(buttonPressed(sender:)))
        button.tag = 2
        button.tintColor = UIColor.white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //테스트
        self.currentDepth = Depth(rawValue: 5)
        //테스트
        
        self.setBackgroundColorOnViewByDepth()
        self.addBlurEffectOnBlurView(view: self.blurView)
        
        self.navigationItem.rightBarButtonItem = self.rightButton
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.menuView = MenuView.instantiate()
    }
    
    func attachMenuView() {
        if let menuView = self.menuView {
            self.addBlurEffectOnMenuView(view: menuView.menuContainerView)
            menuView.menuDelegate = self
            self.view.addSubview(menuView)
        }
    }
    
    func addBlurEffectOnBlurView(view: UIView) {
        self.addBlurEffectOnView(view: view, cornerRadius: 17, blurStyle: UIBlurEffect.Style.light)
    }
    
    func addBlurEffectOnMenuView(view: UIView) {
        self.addBlurEffectOnView(view: view, cornerRadius: 16, blurStyle: UIBlurEffect.Style.systemThinMaterialLight)
    }
    
    func addBlurEffectOnView(view: UIView, cornerRadius: CGFloat?, blurStyle: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.cornerRadius = cornerRadius ?? 0
        blurEffectView.clipsToBounds = true
        view.insertSubview(blurEffectView, at: 0)
    }
    
    func setBackgroundColorOnViewByDepth() {
        let gradientView = UIView(frame: self.view.frame)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = self.currentDepth?.toGradientColor()
        gradientView.layer.addSublayer(gradientLayer)
        self.view.insertSubview(gradientView, at: 0)
    }
    
    @objc private func buttonPressed(sender: Any) {
        if let button = sender as? UIBarButtonItem {
            switch button.tag {
            case 1:
                self.view.backgroundColor = .blue
            case 2:
                print("메뉴버튼")
                if self.menuToggleFlag {
                    self.menuView?.removeFromSuperview()
                } else {
                    self.attachMenuView()
                }
                self.menuToggleFlag = !self.menuToggleFlag
            default:
                print("error")
            }
        }
    }
    
}

extension DiaryViewController: MenuDelegate {
    
    func dateMenuButtonTouchUp(sender: UIButton) {
        print("날짜 수정 모달 팝업")
    }
    
    func depthMenuButtonTouchUp(sender: UIButton) {
        self.pushToDeepViewController()
    }
    
    func diaryMenuButtonTouchUp(sender: UIButton) {
        print("다이어리 수정 페이지로 이동")
    }
    
    func deleteMenubuttonTouchUp(sender: UIButton) {
        print("삭제를 물어보는 센터 모달 띄우기")
    }
    
    func pushToDeepViewController() {
        let onboardingStoryboard = UIStoryboard(name: Constants.Name.onboardingStoryboard, bundle: nil)
        guard let deepViewController = onboardingStoryboard.instantiateViewController(identifier: Constants.Identifier.deepViewController) as? DeepViewController else { return }
        
        deepViewController.initialDepth = self.currentDepth
        
        self.navigationController?.pushViewController(deepViewController, animated: true)
        
    }
}
