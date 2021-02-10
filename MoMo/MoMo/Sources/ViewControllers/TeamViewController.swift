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
    
    // MARK: - Override ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        intializeNavigationItem()
    }
    
    // MARK: - Private Functions
    private func intializeNavigationItem() {
        let leftButton = UIBarButtonItem(image: Constants.Design.Image.btnBackWhite, style: .plain, target: self, action: #selector(popToSettingViewController))
        leftButton.tintColor = UIColor.Black1
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.titleView = self.titleImage
    }
    
    // MARK: - objc Function
    @objc func popToSettingViewController() {
        self.navigationController?.popViewController(animated: true)
    }

}
