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
        
        self.navigationControllerSetUp()
        self.hideDesciptionLabelWithAnimation()
        self.startWaveAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.buttonRoundedUp()
        self.showDesciptionLabelWithAnimation()
    }
    
    // MARK: - Functions
    
    func startWaveAnimation() {
        self.waveAnimationView.contentMode = .scaleAspectFit
        self.waveAnimationView.loopMode = .loop
        self.waveAnimationView.animationSpeed = 0.5
        self.waveAnimationView.play()
    }
    
    func navigationControllerSetUp() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func buttonRoundedUp() {
        self.startButton.layer.cornerRadius = self.startButton.frame.size.height / 2
        self.startButton.clipsToBounds = true
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
        
        self.navigationController?.pushViewController(moodViewController, animated: true)
    }
    
    @IBAction func loginButtonTouchUp(_ sender: UIButton) {
    }
}
