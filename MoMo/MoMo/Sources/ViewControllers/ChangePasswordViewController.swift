//
//  PasswordChangeViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/02/09.
//

import UIKit

struct PasswordInputError {
    enum CurrentPasswordError: Error {
        case noInputError, inValidInputError, missMatchingError
        func toMessage() -> String {
            switch self {
            case .noInputError:
                return "현재 비밀번호를 입력해 주세요"
            case .inValidInputError:
                return "영문+숫자 6자리 이상 입력해 주세요"
            case .missMatchingError:
                return "현재 비밀번호와 일치하지 않습니다"
            }
        }
    }

    enum NewPasswordError: Error {
        case noInputError, inValidInputError, sameAsCurrentPasswordError
        func toMessage() -> String {
            switch self {
            case .noInputError:
                return "새로운 비밀번호를 입력해 주세요"
            case .inValidInputError:
                return "영문+숫자 6자리 이상 입력해 주세요"
            case .sameAsCurrentPasswordError:
                return "현재 비밀번호와 동일합니다"
            }
        }
    }

    enum NewPasswordCheckError: Error {
        case noInputError, missMatchingError
        func toMessage() -> String {
            switch self {
            case .noInputError:
                return "비밀번호를 다시 입력해 주세요"
            case .missMatchingError:
                return "비밀번호가 일치하지 않습니다"
            }
        }
    }
}

enum PasswordInputUsage: Int {
    case current = 0, new, newCheck
}

typealias PasswordInputField = (infoLabel: UILabel, errorLabel: UILabel, inputView: UIView, textField: UITextField, placeholderMessage: String, deleteButton: UIButton)

class ChangePasswordViewController: UIViewController {
    
    // MARK: - IBOutlet Properties

    @IBOutlet weak var currentPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordCheckLabel: UILabel!
    @IBOutlet weak var currentPasswordErrorLabel: UILabel!
    @IBOutlet weak var newPasswordErrorLabel: UILabel!
    @IBOutlet weak var newPasswordCheckErrorLabel: UILabel!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordCheckTextField: UITextField!
    @IBOutlet weak var currentPasswordView: UIView!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var newPasswordCheckView: UIView!
    @IBOutlet weak var currentPasswordDeleteButton: UIButton!
    @IBOutlet weak var newPasswordDeleteButton: UIButton!
    @IBOutlet weak var newPasswordCheckDeleteButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    // MARK: - Properties
    
    private var isMatching: Bool = false
    private var keyboardSize: CGRect?
    private let vSpacingChangePasswordButtonKeyboard: CGFloat = 39
    private let vSpacingChangePasswordButtonViewBottom: CGFloat = 64
    private var passwordInputFieldList: [PasswordInputUsage: PasswordInputField] = [PasswordInputUsage: PasswordInputField]()
    private lazy var rightButton: UIBarButtonItem = {
        let button: UIBarButtonItem = UIBarButtonItem(image: Constants.Design.Image.btnCloseBlack, style: .plain, target: self, action: #selector(buttonPressed(sender:)))
        button.tag = 0
        button.tintColor = UIColor.Black1
        return button
    }()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializePasswordChangeViewController()
        self.initializeNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.currentPasswordTextField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Functions
    
    private func initializePasswordChangeViewController() {
        self.changePasswordButtonRoundedUp()
        self.passwordInputFieldList = [
            .current: (
                infoLabel: self.currentPasswordLabel,
                errorLabel: self.currentPasswordErrorLabel,
                inputView: self.currentPasswordView,
                textField: self.currentPasswordTextField,
                placeholderMessage: "영문+숫자 6자리 이상 입력해 주세요",
                deleteButton: self.currentPasswordDeleteButton
            ),
            .new: (
                infoLabel: self.newPasswordLabel,
                errorLabel: self.newPasswordErrorLabel,
                inputView: self.newPasswordView,
                textField: self.newPasswordTextField,
                placeholderMessage: "영문+숫자 6자리 이상 입력해 주세요",
                deleteButton: self.newPasswordDeleteButton
            ),
            .newCheck: (
                infoLabel: self.newPasswordCheckLabel,
                errorLabel: self.newPasswordCheckErrorLabel,
                inputView: self.newPasswordCheckView,
                textField: self.newPasswordCheckTextField,
                placeholderMessage: "새 비밀번호를 다시 한 번 입력해 주세요",
                deleteButton: self.newPasswordCheckDeleteButton
            )
        ]
        for (passwordInputUsage, _) in self.passwordInputFieldList {
            guard let passwordInputField = passwordInputFieldList[passwordInputUsage] else { return }
            passwordInputField.textField.delegate = self
            passwordInputField.textField.tag = passwordInputUsage.rawValue
            passwordInputField.deleteButton.isHidden = true
            self.showLabelAndTextField(inputField: passwordInputField)
            self.showPlaceHolder(inputField: passwordInputField)
        }
    }
    
    private func getPlaceholderWithAttributedString(message: String) -> NSAttributedString {
        let placeholderAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.Black6]
        let placeholder: NSAttributedString = NSAttributedString(string: message, attributes: placeholderAttributes)
        return placeholder
    }
    
    private func initializeNavigationBar() {
        let titleLabelText: String = "비밀번호 변경"
        let titleLabel: UILabel = UILabel()
        let titleLabelColor = UIColor.Black2Nav
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold), NSAttributedString.Key.foregroundColor: titleLabelColor]
        titleLabel.attributedText = NSAttributedString(string: titleLabelText, attributes: attributes)
        titleLabel.sizeToFit()
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.titleView = titleLabel
        self.navigationItem.rightBarButtonItem = self.rightButton
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    private func changePasswordButtonRoundedUp() {
        self.changePasswordButton.clipsToBounds = true
        self.changePasswordButton.layer.cornerRadius = self.changePasswordButton.frame.size.height/2
    }
    
    private func showPlaceHolder(inputField: PasswordInputField) {
        inputField.textField.attributedText = self.getPlaceholderWithAttributedString(message: inputField.placeholderMessage)
    }
    
    private func showLabelAndTextField(inputField: PasswordInputField) {
        inputField.infoLabel.textColor = UIColor.Blue2
        
        inputField.inputView.layer.masksToBounds = true
        inputField.inputView.layer.borderColor = UIColor.Black5Publish.cgColor
        inputField.inputView.layer.borderWidth = 1.0
        
        inputField.errorLabel.isHidden = true
    }
    
    private func showErrorLabelAndTextField(inputField: PasswordInputField, errorMessage: String) {
        inputField.infoLabel.textColor = UIColor.RedError
        
        inputField.inputView.layer.masksToBounds = true
        inputField.inputView.layer.borderColor = UIColor.RedError.cgColor
        inputField.inputView.layer.borderWidth = 1.0
        
        inputField.errorLabel.isHidden = false
        inputField.errorLabel.text = errorMessage
        
    }
    
    private func isValidPassword(password: String?) -> Bool {
        guard let safePassword = password else { return false }
        guard let regex = try? NSRegularExpression(pattern: "(?=.*[A-Za-z])(?=.*[0-9]).{6,20}") else { return false }
        
        let range = NSRange(location: 0, length: safePassword.utf16.count)
        return regex.firstMatch(in: safePassword, options: [], range: range) != nil
    }
    
    private func sameAsCurrentPassword(password: String?) -> Bool {
        return self.currentPasswordTextField.text == password
    }
    
    private func isMatchedPassword(password: String?, secondPassword: String?) -> Bool {
        return password == secondPassword
    }
    
    private func verifyCurrentPassword(inputField: PasswordInputField) throws {
        guard inputField.textField.text?.isEmpty == false else {
            throw PasswordInputError.CurrentPasswordError.noInputError
        }
        guard self.isValidPassword(password: inputField.textField.text) == true else {
            throw PasswordInputError.CurrentPasswordError.inValidInputError
        }
        
        self.postPasswordWithAPI(currentPassword: inputField.textField.text) { (isMatching) in
            self.isMatching = isMatching
            guard isMatching == true else {
                let error = PasswordInputError.CurrentPasswordError.missMatchingError
                self.showErrorLabelAndTextField(inputField: inputField, errorMessage: error.toMessage())
                return
            }
            self.showLabelAndTextField(inputField: inputField)
        }
    }
    
    private func verifyNewPassword(inputField: PasswordInputField) throws {
        guard inputField.textField.text?.isEmpty == false else {
            throw PasswordInputError.NewPasswordError.noInputError
        }
        guard self.isValidPassword(password: inputField.textField.text) == true else {
            throw PasswordInputError.NewPasswordError.inValidInputError
        }
        guard self.sameAsCurrentPassword(password: inputField.textField.text) == false else {
            throw PasswordInputError.NewPasswordError.sameAsCurrentPasswordError
        }
        self.showLabelAndTextField(inputField: inputField)
    }
    
    private func verifyNewPasswordCheck(inputField: PasswordInputField) throws {
        guard inputField.textField.text?.isEmpty == false else {
            throw PasswordInputError.NewPasswordCheckError.noInputError
        }
        guard self.isMatchedPassword(password: inputField.textField.text, secondPassword: passwordInputFieldList[.new]?.textField.text) == true else {
            throw PasswordInputError.NewPasswordCheckError.missMatchingError
        }
        self.showLabelAndTextField(inputField: inputField)
    }
    
    private func verifyPassword(by usage: PasswordInputUsage) -> Bool {
        guard let passwordInputField = passwordInputFieldList[usage] else { return false }
        switch usage {
        case .current:
            do {
                try verifyCurrentPassword(inputField: passwordInputField)
                return true
            } catch let error as PasswordInputError.CurrentPasswordError {
                self.showErrorLabelAndTextField(inputField: passwordInputField, errorMessage: error.toMessage())
                return false
            } catch {
                return false
            }
        case .new:
            do {
                try verifyNewPassword(inputField: passwordInputField)
                return true
            } catch let error as PasswordInputError.NewPasswordError {
                self.showErrorLabelAndTextField(inputField: passwordInputField, errorMessage: error.toMessage())
                return false
            } catch {
                return false
            }
        case .newCheck:
            do {
                try verifyNewPasswordCheck(inputField: passwordInputField)
                return true
            } catch let error as PasswordInputError.NewPasswordCheckError {
                self.showErrorLabelAndTextField(inputField: passwordInputField, errorMessage: error.toMessage())
                return false
            } catch {
                return false
            }
        }
        
    }
    
    private func popToSettingViewController(passwordIsUpdated: Bool) {
        guard let settingViewController = self.navigationController?.viewControllers.filter({$0 is SettingViewController})[1] as? SettingViewController else {
            return
        }
        settingViewController.passwordIsUpdated = passwordIsUpdated
        self.navigationController?.popToViewController(settingViewController, animated: true)
    }
    
    @objc private func buttonPressed(sender: UIBarButtonItem) {
        switch sender.tag {
        case 0:
            self.popToSettingViewController(passwordIsUpdated: false)
        default:
            return
        }
    }
    
    @IBAction func touchCurrentPasswordButton(_ sender: UIButton) {
        self.currentPasswordTextField.text = nil
        sender.isHidden = true
    }
    
    @IBAction func touchNewPasswordButton(_ sender: UIButton) {
        self.newPasswordTextField.text = nil
        sender.isHidden = true
    }
    
    @IBAction func touchNewPasswordCheckButton(_ sender: UIButton) {
        self.newPasswordCheckTextField.text = nil
        sender.isHidden = true
    }
    
    @IBAction func touchChangePasswordButton(_ sender: UIButton) {
        guard self.verifyPassword(by: .current) == true else { return }
        guard self.verifyPassword(by: .new) == true else { return }
        guard self.verifyPassword(by: .newCheck) == true else { return }
        guard self.isMatching == true else { return }
        guard let newPassword = self.newPasswordTextField.text else { return }
        self.putPasswordWithAPI(newPassword: newPassword, completion: self.popToSettingViewController(passwordIsUpdated:))
    }

    private func dropChangePasswordButton() {
        self.changePasswordButton.frame.origin.y = self.view.frame.size.height - changePasswordButton.frame.size.height - self.vSpacingChangePasswordButtonViewBottom
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardSize = keyboardSize
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        DispatchQueue.main.async {
            self.dropChangePasswordButton()
        }
    }
}

// MARK: - UITextFieldDelegate

extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return false }
        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 16
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let passwordInputUsage = PasswordInputUsage(rawValue: textField.tag) else { return false }
        guard let passwordInputField = passwordInputFieldList[passwordInputUsage] else { return false }
        if textField.text == passwordInputField.placeholderMessage {
            textField.text = nil
        }
        textField.isSecureTextEntry = true
        passwordInputField.deleteButton.isHidden = false
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(self.currentPasswordTextField) {
            self.newPasswordTextField.becomeFirstResponder()
        } else if textField.isEqual(self.newPasswordTextField) {
            self.newPasswordCheckTextField.becomeFirstResponder()
        } else {
            self.newPasswordCheckTextField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let passwordInputUsage = PasswordInputUsage(rawValue: textField.tag) else { return }
        guard let passwordInputField = passwordInputFieldList[passwordInputUsage] else { return }
        passwordInputField.deleteButton.isHidden = true
        _ = self.verifyPassword(by: passwordInputUsage)
    }
}

// MARK: - APIServices

extension ChangePasswordViewController {
    private func postPasswordWithAPI(currentPassword: String?, completion: @escaping (Bool) -> Void ) {
        guard let password = currentPassword else { return }
        PasswordService.shared.postPassword(password: password) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    completion(true)
                }
            case .requestErr(let errorMessage):
                print(errorMessage)
                DispatchQueue.main.async {
                    completion(false)
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
    
    private func putPasswordWithAPI(newPassword: String, completion: @escaping (Bool) -> Void) {
        PasswordService.shared.putPassword(newPassword: newPassword) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    completion(true)
                }
            case .requestErr(let errorMessage):
                DispatchQueue.main.async {
                    completion(false)
                }
                print(errorMessage)
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
