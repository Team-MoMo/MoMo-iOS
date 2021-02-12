//
//  LoginViewController.swift
//  MoMo
//
//  Created by 초이 on 2021/01/12.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    
    var gradientLayer: CAGradientLayer!
    var colorSets = [[CGColor]]() // 단계 별 gradient color 배열
    // TODO: - currentColorSet, depth 중 뭐 쓸건지 정리 필요
    var currentColorSet: Int = 0
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        kakaoLoginButton.clipsToBounds = true
        kakaoLoginButton.layer.cornerRadius = 21
        appleLoginButton.clipsToBounds = true
        appleLoginButton.layer.cornerRadius = 21
        emailLoginButton.clipsToBounds = true
        emailLoginButton.layer.cornerRadius = 21
        
        createGradientColorSets()
        setGradientBackground(depth: currentColorSet)
        
        initializeNavigationBar()
        
    }
    
    // MARK: - Functions
    func initializeNavigationBar() {
        // navigation bar 투명화
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.hidesBackButton = true
    }
    
    func createGradientColorSets() {
        colorSets.append([UIColor.Gradient1.cgColor, UIColor.Gradient2.cgColor]) // 1단계
        colorSets.append([UIColor.Gradient2.cgColor, UIColor.Gradient3.cgColor]) // 2단계
        colorSets.append([UIColor.Gradient3.cgColor, UIColor.Gradient4.cgColor]) // 3단계
        colorSets.append([UIColor.Gradient4.cgColor, UIColor.Gradient5.cgColor]) // 4단계
        colorSets.append([UIColor.Gradient5.cgColor, UIColor.Gradient6.cgColor]) // 5단계
        colorSets.append([UIColor.Gradient6.cgColor, UIColor.Gradient7.cgColor]) // 6단계
        colorSets.append([UIColor.Gradient7.cgColor, UIColor.Gradient8.cgColor]) // 7단계
    }
    
    func setGradientBackground(depth: Int) {
        gradientLayer = CAGradientLayer()
        
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let view = UIView(frame: frame)
        let gradientView = UIView(frame: frame)
        let imgView = UIImageView(frame: view.bounds)
        
        currentColorSet = depth
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.frame
        gradientLayer.colors = colorSets[currentColorSet]
        
        let image = UIImage.gradientImageWithBounds(bounds: frame, colors: colorSets[depth])
        imgView.image = image
        
        view.addSubview(imgView)
        
        backgroundView.addSubview(view)
        backgroundView.sendSubviewToBack(view)
    }
    
    func pushToHomeViewController() {
        let homeStoryboard = UIStoryboard(name: Constants.Name.homeStoryboard, bundle: nil)
        let dvc = homeStoryboard.instantiateViewController(identifier: Constants.Identifier.homeViewController)
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    // MARK: - @IBAction Properties
    
    @IBAction func touchEmailLoginButton(_ sender: Any) {
        let emailLoginStoryboard = UIStoryboard(name: Constants.Name.emailLoginStoryboard, bundle: nil)
        let dvc = emailLoginStoryboard.instantiateViewController(identifier: Constants.Identifier.emailLoginViewController)
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    @IBAction func touchAppleLoginButton(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if let identityToken = appleIDCredential.identityToken,
               let tokenString = String(data: identityToken, encoding: .utf8) {
                postSocialSignInWithAPI(socialName: "apple", accessToken: tokenString)
            }
            
        case let passwordCredential as ASPasswordCredential:
            
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                // self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
    
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

extension LoginViewController {
    func postSocialSignInWithAPI(socialName: String, accessToken: String) {
        SignInService.shared.postSocialSignIn(socialName: socialName, accessToken: accessToken) { (networkResult) -> Void in
            switch networkResult {
            case .success(let data):
                if let signInData = data as? AuthData {
                    print("회원가입 성공")
                    // 회원가입 성공
                    UserDefaults.standard.setValue(signInData.token, forKey: "token")
                    UserDefaults.standard.setValue(signInData.user.id, forKey: "userId")
                    UserDefaults.standard.setValue("apple", forKey: "loginType")
                    
                    // 뷰 전환
                    let homeStoryboard = UIStoryboard(name: Constants.Name.homeStoryboard, bundle: nil)
                    let dvc = homeStoryboard.instantiateViewController(identifier: Constants.Identifier.homeViewController)
                    self.navigationController?.pushViewController(dvc, animated: true)
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr in postSignUpWithAPI")
            case .serverErr:
                print("serverErr in postSignUpWithAPI")
            case .networkFail:
                print("networkFail in postSignUpWithAPI")
            }
        }
    }
}
