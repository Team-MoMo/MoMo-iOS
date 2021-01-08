//
//  OnboardingViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/07.
//

import UIKit

class OnboardingViewController: UIViewController {


    @IBOutlet weak var tutorialStartButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tutorialButtonTouchUp(_ sender: UIButton) {
        
        guard let onboardingMoodViewController = self.storyboard?.instantiateViewController(identifier: "OnboardingMoodViewController") else { return }
        
        self.navigationController?.pushViewController(onboardingMoodViewController, animated: true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
