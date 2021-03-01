//
//  OnboardingViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/07.
//

import UIKit
import Lottie

class OnboardingViewController: UIViewController {

    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var waveAnimationView: AnimationView!
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeNavigationBar()
        self.hideDesciptionLabelWithAnimation()
        self.startWaveAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.buttonRoundedUp()
        self.showDesciptionLabelWithAnimation()
    }
    
    // MARK: - Functions
    
    private func initializeOnboardingViewController() {
        self.buttonRoundedUp()
        
        self.infoLabel.attributedText = "감정 기록이\n어려웠던 적이 있나요?".textSpacing()
        self.descriptionLabel.attributedText = "오늘부터는 책 속의 문장이\n당신의 감정 기록을 도와줄 거예요.\n\n다양한 감정의 폭을 바다의 깊이로 표현해보세요.".textSpacing()
    }
    
    private func initializeNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func buttonRoundedUp() {
        self.startButton.layer.cornerRadius = self.startButton.frame.size.height / 2
        self.startButton.clipsToBounds = true
    }
    
    func startWaveAnimation() {
        self.waveAnimationView.contentMode = .scaleAspectFit
        self.waveAnimationView.loopMode = .loop
        self.waveAnimationView.animationSpeed = 0.5
        self.waveAnimationView.play()
    }
    
    func hideDesciptionLabelWithAnimation() {
        self.descriptionLabel.alpha = 0.0
    }
    
    func showDesciptionLabelWithAnimation() {
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            animations: {
                self.descriptionLabel.alpha = 1.0
            }
        )
    }
    
    @IBAction func startButtonTouchUp(_ sender: UIButton) {
        guard let moodViewController = self.storyboard?.instantiateViewController(identifier: Constants.Identifier.moodViewController) as? MoodViewController else { return }
        moodViewController.changeUsage = true
        self.navigationController?.pushViewController(moodViewController, animated: true)
    }
    
    @IBAction func loginButtonTouchUp(_ sender: UIButton) {
        let loginStoryboard = UIStoryboard(name: Constants.Name.loginStoryboard, bundle: nil)
        let dvc = loginStoryboard.instantiateViewController(identifier: Constants.Identifier.loginViewController)
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}
