//
//  OnboardingViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/07.
//

import UIKit

class OnboardingViewController: UIViewController {

    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var tutorialStartButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func tutorialButtonTouchUp(_ sender: UIButton) {
        
        guard let onboardingMoodViewController = self.storyboard?.instantiateViewController(identifier: Constants.Identifier.onboardingMoodViewController) as? OnboardingMoodViewController else { return }
        
        self.navigationController?.pushViewController(onboardingMoodViewController, animated: true)
        
    }
}
