//
//  EmailLoginViewController.swift
//  MoMo
//
//  Created by 초이 on 2021/01/12.
//

import UIKit

class EmailLoginViewController: UIViewController {
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorMessageTop: NSLayoutConstraint!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var loginButtonTop: NSLayoutConstraint!
    
    // MARK: - Properties
    
    // 가입하지 않은 회원일 때
    let isEmailCheckError: Bool = false
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 로그인 버튼 rounding
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        
        // 가입하지 않은 회원 label 분기 처리
        if isEmailCheckError {
            errorMessageTop.constant = 76
            errorMessageLabel.isHidden = false
            loginButtonTop.constant = 72
        } else {
            errorMessageTop.constant = 0
            errorMessageLabel.isHidden = true
            loginButtonTop.constant = 0
        }
        
        // placeholder
        emailTextField.attributedPlaceholder = NSAttributedString(string: "이메일을 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.Blue5, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "영문 + 숫자 6자리 이상 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.Blue5, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)])
        
        // navigation bar 투명화
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
}
