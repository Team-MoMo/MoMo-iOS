//
//  OnboardingSentenceViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/07.
//

import UIKit

class OnboardingSentenceViewController: UIViewController {

    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var moodIcon: UIImageView!
    
    @IBOutlet weak var firstAuthorLabel: UILabel!
    @IBOutlet weak var firstBookTitleLabel: UILabel!
    @IBOutlet weak var firstPublisherLabel: UILabel!
    @IBOutlet weak var firstSentenceLabel: UILabel!
            
    @IBOutlet weak var secondAuthorLabel: UILabel!
    @IBOutlet weak var secondBookTitleLabel: UILabel!
    @IBOutlet weak var secondPublisherLabel: UILabel!
    @IBOutlet weak var secondSentenceLabel: UILabel!
    
    @IBOutlet weak var thirdAuthorLabel: UILabel!
    @IBOutlet weak var thirdBookTitleLabel: UILabel!
    @IBOutlet weak var thirdPublisherLabel: UILabel!
    @IBOutlet weak var thirdSentenceLabel: UILabel!
    
    private var buttons: [Button] = []
    var mood: Mood?
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttons = [Button(button: firstButton), Button(button: secondButton), Button(button: thirdButton)]
        
        for button in buttons {
            button.buttonsRoundedUp()
            button.buttonsAddShadow()
        }
        
        self.moodLabel.text = self.mood?.toString()
        self.moodIcon.image = self.mood?.toIcon()
        self.dateLabel.text = self.date
        
    }

    @IBAction func firstButtonTouchUp(_ sender: UIButton) {
    }
    
    @IBAction func secondButtonTouchUp(_ sender: UIButton) {
    }
    @IBAction func thirdButtonTouchUp(_ sender: UIButton) {
    }
}
