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
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var findPasswordButton: UIButton!
    
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

        initializeConstraints()
        initializeButtonRounding()
        initializeErrorMessageLabel()
        initializeTextSpacing()
        initializePlaceholder()
        initializeNavigationBar()
        
    }
    
    // MARK: - Functions
    
    private func initializeConstraints() {
        errorMessageTop.constant = 50
        loginButtonTop.isActive = true
        loginButtonTop.constant = 50
        joinStackViewBottom.constant = 10
    }
    
    private func initializeButtonRounding() {
        // 로그인 버튼 rounding
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
    }
    
    private func initializeTextSpacing() {
        emailLabel.attributedText = emailLabel.text?.textSpacing()
        passwordLabel.attributedText = passwordLabel.text?.textSpacing()
        errorMessageLabel.attributedText = errorMessageLabel.text?.wordTextSpacing(textSpacing: -0.6, lineSpacing: 4, center: true, truncated: false)
        loginButton.titleLabel?.attributedText = loginButton.titleLabel?.text?.textSpacing()
        joinButton.titleLabel?.attributedText = joinButton.titleLabel?.text?.textSpacing()
        findPasswordButton.titleLabel?.attributedText = findPasswordButton.titleLabel?.text?.textSpacing()
    }
    
    private func initializePlaceholder() {
        // placeholder
        emailTextField.attributedPlaceholder = NSAttributedString(string: "이메일을 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.Blue5, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular), NSAttributedString.Key.kern: -0.6 ])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "영문 + 숫자 6자리 이상 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.Blue5, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular), NSAttributedString.Key.kern: -0.6])
    }
    
    private func initializeErrorMessageLabel() {
        // 가입하지 않은 회원 label 분기 처리
        if isEmailCheckError {
            errorMessageLabel.isHidden = false
        } else {
            errorMessageLabel.isHidden = true
        }
        
        // placeholder
        emailTextField.attributedPlaceholder = NSAttributedString(string: "이메일을 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.Blue5, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "영문 + 숫자 6자리 이상 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.Blue5, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)])
        
        initializeNavigationBar()
    }
    
    // MARK: - Functions
    
    func initializeNavigationBar() {
        // navigation bar 투명화
        self.navigationItem.leftBarButtonItem = self.leftButton
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.hidesBackButton = true
        
        // edge pan gesture 추가
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        // navigation bar 숨기기 취소
        self.navigationController?.isNavigationBarHidden = false
    }
    
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
        self.attachActivityIndicator()
        SignInService.shared.postSignIn(email: emailText, password: passwordText) { networkResult in
            self.detachActivityIndicator()
            switch networkResult {
            case .success(let data):
                if let signInData = data as? AuthData {
                    self.errorMessageLabel.isHidden = true
                    
                    APIConstants.userId = signInData.user.id
                    UserDefaults.standard.setValue(signInData.token, forKey: "token")
                    UserDefaults.standard.setValue(signInData.user.id, forKey: "userId")
                    UserDefaults.standard.setValue("email", forKey: "loginType")
                    UserDefaults.standard.setValue(false, forKey: "didLogin")
                    
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            case .requestErr(let msg):
                if let _ = msg as? String {
                    self.errorMessageLabel.isHidden = false
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
