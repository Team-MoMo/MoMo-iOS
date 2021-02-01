//
//  StatisticsViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/29.
//

import UIKit

class StatisticsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeNavigationItem()

    }
    
    private func initializeNavigationItem() {
        let backButton = UIBarButtonItem(image: Constants.Design.Image.btnBackBlack, style: .plain, target: self, action: #selector(touchBackButton))
        backButton.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "이 달의 통계"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.Black1]
        
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
