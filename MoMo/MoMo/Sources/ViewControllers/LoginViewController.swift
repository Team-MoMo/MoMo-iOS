//
//  LoginViewController.swift
//  MoMo
//
//  Created by 초이 on 2021/01/12.
//

import UIKit

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
        
        // navigation bar 투명화
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

    }
    
    // MARK: - Functions
    // TODO: - gradient color 머지되면 수정
    func createGradientColorSets() {
        colorSets.append([UIColor.Blue1.cgColor, UIColor.Blue4.cgColor]) // 1단계
        colorSets.append([UIColor.yellow.cgColor, UIColor.yellow.cgColor]) // 2단계
        colorSets.append([UIColor.red.cgColor, UIColor.red.cgColor]) // 3단계
        colorSets.append([UIColor.yellow.cgColor, UIColor.yellow.cgColor]) // 4단계
        colorSets.append([UIColor.red.cgColor, UIColor.red.cgColor]) // 5단계
        colorSets.append([UIColor.yellow.cgColor, UIColor.yellow.cgColor]) // 6단계
        colorSets.append([UIColor.red.cgColor, UIColor.red.cgColor]) // 7단계
    }
    
    func setGradientBackground(depth: Int) {
        gradientLayer = CAGradientLayer()
        
        let frame = self.backgroundView.frame
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
}

// TODO: - 기존 PR 머지되면 삭제
// MARK: - extension UIImage - gradient
extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
