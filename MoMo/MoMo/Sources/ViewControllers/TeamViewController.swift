//
//  TeamViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/02/10.
//

import UIKit

class TeamViewController: UIViewController {

    // MARK: - Properties
    private lazy var titleImage: UIImageView = {
        let image: UIImageView = UIImageView()
        image.image = Constants.Design.Image.imgTypoMomo
        return image
    }()
    
    let mainColor: UIColor? =  UIColor(red: 238/255, green: 249/255, blue: 255/255, alpha: 1.0)
    // MARK: - Override ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeNavigationBarColor()
        intializeNavigationItem()
        initializeStatusBarColor()
        
    }
    
    // MARK: - Private Functions
    private func intializeNavigationItem() {
        let leftButton = UIBarButtonItem(image: Constants.Design.Image.btnBackWhite, style: .plain, target: self, action: #selector(popToSettingViewController))
        leftButton.tintColor = UIColor.Black1
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.titleView = self.titleImage
    }
    
    private func initializeNavigationBarColor() {
        guard let color = mainColor else {
            return
        }
        self.navigationController?.navigationBar.backgroundColor = color
    }
    
    private func initializeStatusBarColor() {
        guard let color = mainColor else {
            return
        }
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            guard let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height else {
                return
            }
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = color
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor.constraint(equalToConstant: statusBarHeight).isActive = true

            statusbarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = color
        }
    }
    
    // MARK: - objc Function
    @objc func popToSettingViewController() {
        self.navigationController?.navigationBar.backgroundColor = .none
        self.navigationController?.popViewController(animated: true)
    }

}
