//
//  JoinViewController.swift
//  MoMo
//
//  Created by 초이 on 2021/01/12.
//

import UIKit

class JoinViewController: UIViewController {
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordCheckView: UIView!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordCheckLabel: UILabel!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var passwordCheckErrorLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    
    @IBOutlet weak var infoAgreeButton: UIButton!
    @IBOutlet weak var serviceAgreeButton: UIButton!
    
    @IBOutlet weak var infoTermButton: UIButton!
    @IBOutlet weak var serviceTermButton: UIButton!
    
    @IBOutlet weak var joinButton: UIButton!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // view border
        emailView.layer.borderColor = UIColor.Black5Publish.cgColor
        emailView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor.Black5Publish.cgColor
        passwordView.layer.borderWidth = 1
        passwordCheckView.layer.borderColor = UIColor.Black5Publish.cgColor
        passwordCheckView.layer.borderWidth = 1
        
        // navigation bar 투명화
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        // joinButton rounding
        joinButton.clipsToBounds = true
        joinButton.layer.cornerRadius = joinButton.frame.height / 2
        
        // placeholder
        emailTextField.attributedPlaceholder = NSAttributedString(string: "이메일을 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.Blue5, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)])

        passwordTextField.attributedPlaceholder = NSAttributedString(string: "영문 + 숫자 6자리 이상 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.Blue5, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)])
        
        passwordCheckTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호를 다시 한 번 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.Blue5, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)])
        
        // 약관 동의 시 checkbox toggle
        infoAgreeButton.setImage(Constants.Design.Image.loginCheckboxIntermediate, for: .normal)
        infoAgreeButton.setImage(Constants.Design.Image.loginCheckbox, for: .selected)
        serviceAgreeButton.setImage(Constants.Design.Image.loginCheckboxIntermediate, for: .normal)
        serviceAgreeButton.setImage(Constants.Design.Image.loginCheckbox, for: .selected)
        
        // 처음 뷰 로드 시 error label hidden 처리
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        passwordCheckErrorLabel.isHidden = true
        
        // clear button 만들기
        emailTextField.modifyClearButtonWithImage(image: Constants.Design.Image.textfieldDelete ?? UIImage())
        passwordTextField.modifyClearButtonWithImage(image: Constants.Design.Image.textfieldDelete ?? UIImage())
        passwordCheckTextField.modifyClearButtonWithImage(image: Constants.Design.Image.textfieldDelete ?? UIImage())
        
        // 약관 동의 체크박스 부분 bold처리
        let boldText = "[필수]"
        let attrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        let infoTermAttributedString = NSMutableAttributedString(string: boldText, attributes: attrs)
        let serviceTermAttributedString = NSMutableAttributedString(string: boldText, attributes: attrs)

        let infoTerm = " 개인정보 수집이용 동의"
        let infoTermString = NSMutableAttributedString(string: infoTerm)
        
        let serviceTerm = " 서비스 이용약관 동의"
        let serviceTermString = NSMutableAttributedString(string: serviceTerm)

        infoTermAttributedString.append(infoTermString)
        serviceTermAttributedString.append(serviceTermString)
        
        infoTermButton.setAttributedTitle(infoTermAttributedString, for: .normal)
        serviceTermButton.setAttributedTitle(serviceTermAttributedString, for: .normal)
    }
    
    // MARK: - @IBAction Properties
    
    @IBAction func infoButtonTouchUp(_ sender: Any) {
        // 약관 동의 시 checkbox toggle
        infoAgreeButton.isSelected.toggle()
    }
    @IBAction func serviceButtonTouchUp(_ sender: Any) {
        serviceAgreeButton.isSelected.toggle()
    }
    
extension UITextField {
    func modifyClearButtonWithImage(image: UIImage) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:) ), for: .touchUpInside)
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
    }

    @objc func clear(sender: AnyObject) {
        self.text = ""
        sendActions(for: .editingChanged)
    }
}
