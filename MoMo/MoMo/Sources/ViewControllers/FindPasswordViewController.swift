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
    private let emailNotFoundErrorMessage = "존재하지 않는 회원"
    private let countErrorMessage = "임시 비밀번호 발급 횟수 초과"
    
    private let getPasswordButtonBottomConstraint = 30
    
    // MARK: - Properties
    var getPasswordAlertView: GetPasswordAlertView?
    var todayPasswordCount: Int = 0
    
    private lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: Constants.Design.Image.btnBackWhite, style: .plain, target: self, action: #selector(touchNavigationButton(sender:)))
        button.tintColor = UIColor.Black1
        button.tag = 0
        return button
    }()
    
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
        
        initializeTodayPasswordCount()
        initializeViewBorders()
        initializeNavigationBar()
        initializeGetPasswordButtonCornerRadius()
        initializePlaceholder()
        hideEmailError()
        makeClearButton()
        registerXib()
        
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
    
    func registerXib() {
        self.getPasswordAlertView = Bundle.main.loadNibNamed(Constants.Name.getPasswordAlertViewXib, owner: self, options: nil)?.last as? GetPasswordAlertView
    }
    
    func initializeTodayPasswordCount() {
        todayPasswordCount = 0
    }
    
    func initializeViewBorders() {
        // view border
        emailView.layer.borderColor = UIColor.Black5Publish.cgColor
        emailView.layer.borderWidth = 1
    }
    
    func initializeNavigationBar() {
        self.navigationItem.leftBarButtonItem = self.leftButton
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
            
            getPasswordButtonBottom.constant = CGFloat(getPasswordButtonBottomConstraint) + keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            getPasswordButtonBottom.constant = CGFloat(getPasswordButtonBottomConstraint)
        }
    }
    
    private func popToLoginViewController() {
        self.navigationController?.popViewController(animated: true)
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
    
    func showAlert(style: UIAlertController.Style) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: style)
        let success = UIAlertAction(title: "확인", style: .default) { (action) in
            // 확인 버튼 누른 후 할 일
        }
        
        // alertviewcontroller background color 지정
        if let bgView = alert.view.subviews.first,
            let groupView = bgView.subviews.first,
            let contentView = groupView.subviews.first {
            contentView.backgroundColor = UIColor.white
        }
        
        alert.setValue(creatCustomVC(), forKey: "contentViewController")
        alert.addAction(success)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func creatCustomVC() -> UIViewController {

        let customVC = UIViewController()

        let containerView = getPasswordAlertView
        
        if todayPasswordCount == 1 {
            todayPasswordCount += 1
            containerView?.showOnce()
        } else if todayPasswordCount == 2 {
            todayPasswordCount += 1
            containerView?.showTwice()
        } else if todayPasswordCount == 3 {
            todayPasswordCount += 1
            containerView?.showThrice()
        } else {
            containerView?.showError()
        }
        
        customVC.view = containerView
        customVC.preferredContentSize.width = 290
        customVC.preferredContentSize.height = 204

        return customVC
    }
    
    // MARK: - @IBAction Functions
    @IBAction func touchGetPasswordButton(_ sender: Any) {
        checkEmail()
        // showAlert(style: .alert)
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
            self.postTempPasswordWithAPI(email: email)
        } else {
            self.showEmailBlankError()
        }
    }
    
    // MARK: - API Functions
    // 이메일 확인
    
    func postTempPasswordWithAPI(email: String) {
        PasswordService.shared.postTempPassword(email: email) { (networkResult) -> Void in
            switch networkResult {
            case .success(let data):
                if let tempPasswordData = data as? TempPassword {
                    // 사용 가능한 이메일
                    self.hideEmailError()
                    self.todayPasswordCount = tempPasswordData.tempPasswordIssueCount
                    self.showAlert(style: .alert)
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    // 사용 불가능한 이메일
                    if message == self.emailFormatErrorMessage {
                        self.showEmailFormatError()
                    } else if message == self.countErrorMessage {
                        self.todayPasswordCount = 4
                        self.showAlert(style: .alert)
                    } else if message == self.emailNotFoundErrorMessage {
                        self.showEmailNotFoundError()
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
