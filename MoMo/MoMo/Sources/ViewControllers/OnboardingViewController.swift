//
//  OnboardingViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/07.
//

import UIKit

class OnboardingViewController: UIViewController {

    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationControllerSetUp()
        self.hideDesciptionLabelWithAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.buttonRoundedUp()
        self.showDesciptionLabelWithAnimation()
    }
    
    // MARK: - Functions
    
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
