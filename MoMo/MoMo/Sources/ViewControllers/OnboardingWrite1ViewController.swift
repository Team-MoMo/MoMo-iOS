//
//  OnboardingWrite1ViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/07.
//

import UIKit

class OnboardingWrite1ViewController: UIViewController {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var sentenceLabel: UILabel!
    
    @IBOutlet weak var onboardingCircleSmall: UIImageView!
    @IBOutlet weak var onboardingCircleBig: UIImageView!
    
    var selectedSentence: Sentence?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
