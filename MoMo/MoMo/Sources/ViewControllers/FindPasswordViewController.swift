//
//  FindPasswordViewController.swift
//  MoMo
//
//  Created by 초이 on 2021/01/13.
//

import UIKit

class FindPasswordViewController: UIViewController {
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var getPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view border
        emailView.layer.borderColor = UIColor.Black5Publish.cgColor
        emailView.layer.borderWidth = 1
        
        // navigation bar 투명화
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        // joinButton rounding
        getPasswordButton.clipsToBounds = true
        getPasswordButton.layer.cornerRadius = getPasswordButton.frame.height / 2
        
        // placeholder
        emailTextField.attributedPlaceholder = NSAttributedString(string: "이메일을 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.Blue5, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)])
        
        // 처음 뷰 로드 시 error label hidden 처리
        emailErrorLabel.isHidden = true
        
        // clear button 만들기
        emailTextField.modifyClearButtonWithImage(image: Constants.Design.Image.textfieldDelete ?? UIImage())
    }
    
    // MARK: - Functions
    
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

}
