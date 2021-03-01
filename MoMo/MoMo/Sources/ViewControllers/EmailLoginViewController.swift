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
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    private lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: Constants.Design.Image.btnBackWhite, style: .plain, target: self, action: #selector(touchNavigationButton(sender:)))
        button.tintColor = UIColor.Black1
        button.tag = 0
        return button
    }()
    
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
        self.navigationItem.leftBarButtonItem = self.leftButton
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.hidesBackButton = true
        
        
        // navigation bar 숨기기 취소
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    // MARK: - Functions
    
    private func pushToHomeViewController() {
        if let homeViewController = self.navigationController?.viewControllers.filter({$0 is HomeViewController}).first as? HomeViewController {
            self.navigationController?.popToViewController(homeViewController, animated: true)
        } else {
            let homeStoryboard = UIStoryboard(name: Constants.Name.homeStoryboard, bundle: nil)
            guard let homeViewController = homeStoryboard.instantiateViewController(identifier: Constants.Identifier.homeViewController) as? HomeViewController else { return }
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
    
    private func popToLoginViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func attachActivityIndicator() {
        self.view.addSubview(self.activityIndicator)
    }
    
    private func detachActivityIndicator() {
        if self.activityIndicator.isAnimating {
            self.activityIndicator.stopAnimating()
        }
        self.activityIndicator.removeFromSuperview()
    }
    
    @objc private func touchNavigationButton(sender: Any) {
        if let button = sender as? UIBarButtonItem {
            switch button.tag {
            case 0:
                self.popToLoginViewController()
            default:
                return
            }
        }
    }
    
    // MARK: - @IBAction Properties
    
    @IBAction func touchUpLoginButton(_ sender: Any) {
        self.attachActivityIndicator()
        self.postSignInWithAPI(completion: self.pushToHomeViewController)
    }
    
    @IBAction func touchUpJoinButton(_ sender: Any) {
        let joinStoryboard = UIStoryboard(name: Constants.Name.joinStoryboard, bundle: nil)
        let dvc = joinStoryboard.instantiateViewController(identifier: Constants.Identifier.joinViewController)
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    @IBAction func touchUpFindPasswordButton(_ sender: Any) {
        let findPasswordStoryboard = UIStoryboard(name: Constants.Name.findPasswordStoryboard, bundle: nil)
        let dvc = findPasswordStoryboard.instantiateViewController(identifier: Constants.Identifier.findPasswordViewController)
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}

// MARK: - API Services

extension EmailLoginViewController {
    private func postSignInWithAPI(completion: @escaping () -> Void) {
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
                    
                    APIConstants.userId = signInData.user.id
                    UserDefaults.standard.setValue(signInData.token, forKey: "token")
                    UserDefaults.standard.setValue(signInData.user.id, forKey: "userId")
                    UserDefaults.standard.setValue("email", forKey: "loginType")
                    
                    self.detachActivityIndicator()
                    
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            case .requestErr(let msg):
                
                self.detachActivityIndicator()
                
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
}
