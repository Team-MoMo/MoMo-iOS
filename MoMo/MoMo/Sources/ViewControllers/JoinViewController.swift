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
        
    }
}
