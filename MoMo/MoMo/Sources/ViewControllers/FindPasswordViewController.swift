//
//  FindPasswordViewController.swift
//  MoMo
//
//  Created by 초이 on 2021/01/13.
//

import UIKit

class FindPasswordViewController: UIViewController {
    
    // MARK: - Constants
        private let emailFormatErrorMessage = "email must be a valid email"
        private let emailInUseErrorMessage = "사용 불가능한 이메일입니다."
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var getPasswordButton: UIButton!
    @IBOutlet weak var getPasswordButtonBottom: NSLayoutConstraint!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViewBorders()
        initializeNavigationBar()
        initializeGetPasswordButtonCornerRadius()
        initializePlaceholder()
        hideEmailError()
        makeClearButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        initializeKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        removeKeyboardObserver()
    }
    
    // MARK: - Functions
    func initializeViewBorders() {
        // view border
        emailView.layer.borderColor = UIColor.Black5Publish.cgColor
        emailView.layer.borderWidth = 1
    }
    
    func initializeNavigationBar() {
        // navigation bar 투명화
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func initializeGetPasswordButtonCornerRadius() {
        // getPasswordButton rounding
        getPasswordButton.clipsToBounds = true
        getPasswordButton.layer.cornerRadius = getPasswordButton.frame.height / 2
    }
    
    func initializePlaceholder() {
        // placeholder
        emailTextField.attributedPlaceholder = NSAttributedString(string: "이메일을 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.Blue5, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)])
    }
    
    func makeClearButton() {
        // clear button 만들기
        emailTextField.modifyClearButtonWithImage(image: Constants.Design.Image.textfieldDelete ?? UIImage())
    }
    
    func initializeKeyboardObserver() {
        // keyboardWillShow, keyboardWillHide observer 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        // observer 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            getPasswordButtonBottom.constant += keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        // 원하는 로직...
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            getPasswordButtonBottom.constant -= keyboardHeight
        }
    }
    
    // MARK: - @IBAction Functions
    @IBAction func touchGetPasswordButton(_ sender: Any) {
        
    }
    
    // MARK: - Error Functions
    
    // Email Errors
    func showEmailFormatError() {
        emailErrorLabel.isHidden = false
        emailErrorLabel.text = "올바른 이메일 형식이 아닙니다"
        
        emailLabel.textColor = UIColor.RedError
        emailView.layer.borderColor = UIColor.RedError.cgColor
    }
    
    func showEmailBlankError() {
        emailErrorLabel.isHidden = false
        emailErrorLabel.text = "이메일을 입력해 주세요"
        
        emailLabel.textColor = UIColor.RedError
        emailView.layer.borderColor = UIColor.RedError.cgColor
    }
    
    func showEmailNotFoundError() {
        emailErrorLabel.isHidden = false
        emailErrorLabel.text = "가입된 이메일이 없습니다"
        
        emailLabel.textColor = UIColor.RedError
        emailView.layer.borderColor = UIColor.RedError.cgColor
    }
    
    func hideEmailError() {
        // 처음 뷰 로드 시 error label hidden 처리
        emailErrorLabel.isHidden = true
    }
    
    // MARK: - Check Functions
    func checkEmail() {
        guard let email = emailTextField.text else {
            return
        }
        if email != "" {
            self.getSignUpWithAPI(email: email)
        } else {
            self.showEmailBlankError()
        }
    }
    
    // MARK: - API Functions
    // 이메일 확인
    
    // TODO: - 서버 살아나면 이거 서버 구현해야함 이거 아니라 패스워드쪽으로 해야함 이거 아님!
    func getSignUpWithAPI(email: String) {
        SignUpService.shared.getSignUp(email: email) { (networkResult) -> Void in
            switch networkResult {
            case .success(let msg):
                if let message = msg as? String {
                    // 사용 가능한 이메일
                    self.hideEmailError()
                    print(message)
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    // 사용 불가능한 이메일
                    if message == self.emailFormatErrorMessage {
                        self.showEmailFormatError()
                    } else if message == self.emailInUseErrorMessage {
                        // self.showEmailInUseError()
                    }
                    print(message)
                }
            case .pathErr:
                print("pathErr in getSignUpWithApi")
                
            case .serverErr:
                print("serverErr in getSignUpWithApi")
            case .networkFail:
                print("networkFail in getSignUpWithApi")
            }
        }
    }
}
    
    extension FindPasswordViewController: UITextFieldDelegate {
        func textFieldDidEndEditing(_ textField: UITextField) {
            
            // 이메일
            if textField == emailTextField {
                checkEmail()
                
                // 비밀번호
            }
        }
    }
