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
    @IBOutlet weak var joinStackViewBottom: NSLayoutConstraint!
    
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
            loginButtonTop.isActive = true
            loginButtonTop.constant = 72
            //joinStackViewBottom.isActive = false
            joinStackViewBottom.constant = 0
        } else {
            errorMessageTop.constant = 0
            errorMessageLabel.isHidden = true
            //loginButtonTop.isActive = false
            loginButtonTop.constant = 0
            joinStackViewBottom.isActive = true
            joinStackViewBottom.constant = 69
        }
        
        // placeholder
        emailTextField.attributedPlaceholder = NSAttributedString(string: "이메일을 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.Blue5, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "영문 + 숫자 6자리 이상 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.Blue5, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)])
        
        // navigation bar 투명화
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    // MARK: - @IBAction Properties
    @IBAction func touchUpLoginButton(_ sender: Any) {
        guard let emailText = emailTextField.text,
              let passwordText = passwordTextField.text else {
            return
        }
        
        SignInService.shared.postSignIn(email: emailText, password: passwordText) { networkResult in
            switch networkResult {
            case .success(let data):
                if let signInData = data as? AuthData {
                    self.errorMessageTop.constant = 0
                    self.errorMessageLabel.isHidden = true
                    // self.loginButtonTop.isActive = false
                    self.loginButtonTop.constant = 0
                    self.joinStackViewBottom.isActive = true
                    self.joinStackViewBottom.constant = 69
                    
                    UserDefaults.standard.setValue(signInData.token, forKey: "token")
                    UserDefaults.standard.setValue(signInData.user.id, forKey: "userId")
                    
                    if let homeViewController = self.navigationController?.viewControllers.filter({$0 is HomeViewController}).first as? HomeViewController {
                        homeViewController.isFromLogout = false
                        self.navigationController?.popToViewController(homeViewController, animated: true)
                    } else {
                        let homeStoryboard = UIStoryboard(name: Constants.Name.homeStoryboard, bundle: nil)
                        guard let homeViewController = homeStoryboard.instantiateViewController(identifier: Constants.Identifier.homeViewController) as? HomeViewController else { return }
                        self.navigationController?.pushViewController(homeViewController, animated: true)
                    }
                }
            case .requestErr(let msg):
                if let _ = msg as? String {
                    self.errorMessageTop.constant = 76
                    self.errorMessageLabel.isHidden = false
                    self.loginButtonTop.isActive = true
                    self.loginButtonTop.constant = 72
                    // joinStackViewBottom.isActive = false
                    self.joinStackViewBottom.constant = 0
                }
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
        
    }
    @IBAction func touchUpJoinButton(_ sender: Any) {
        let joinStoryboard = UIStoryboard(name: Constants.Name.joinStoryboard, bundle: nil)
        let dvc = joinStoryboard.instantiateViewController(identifier: Constants.Identifier.joinViewController)
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    @IBAction func touchUpFindPasswordButton(_ sender: Any) {
        // let findPasswordStoryboard = UIStoryboard(name: Constants.Name.findPasswordStoryboard, bundle: nil)
        // let dvc = emailLoginStoryboard.instantiateViewController(identifier: Constants.Identifier.emailLoginViewController)
        // self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    
}
