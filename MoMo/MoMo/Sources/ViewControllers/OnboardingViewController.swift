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
    
    private func initializeNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func buttonRoundedUp() {
        self.startButton.layer.cornerRadius = self.startButton.frame.size.height / 2
        self.startButton.clipsToBounds = true
    }
    
    private func startWaveAnimation() {
        self.waveAnimationView.contentMode = .scaleAspectFit
        self.waveAnimationView.loopMode = .loop
        self.waveAnimationView.animationSpeed = 0.5
        self.waveAnimationView.play()
    }
    
    private func hideDesciptionLabelWithAnimation() {
        self.descriptionLabel.alpha = 0.0
    }
    
    private func showDesciptionLabelWithAnimation() {
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            animations: {
                self.descriptionLabel.alpha = 1.0
            }
        )
    }
    
    private func pushToMoodViewController() {
        guard let moodViewController = self.storyboard?.instantiateViewController(identifier: Constants.Identifier.moodViewController) as? MoodViewController else { return }
        moodViewController.moodViewUsage = .onboarding
        self.navigationController?.pushViewController(moodViewController, animated: true)
    }
    
    private func pushToLoginViewController() {
        let loginStoryboard = UIStoryboard(name: Constants.Name.loginStoryboard, bundle: nil)
        let dvc = loginStoryboard.instantiateViewController(identifier: Constants.Identifier.loginViewController)
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    @IBAction func startButtonTouchUp(_ sender: UIButton) {
        self.pushToMoodViewController()
    }
    
    @IBAction func loginButtonTouchUp(_ sender: UIButton) {
        self.pushToLoginViewController()
    }
}
