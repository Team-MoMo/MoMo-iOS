//
//  OnboardingSentenceViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/07.
//

import UIKit

struct Sentence {
    var author: String?
    var bookTitle: String?
    var publisher: String?
    var sentence: String?
}

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
    var selectedMood: Mood?
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttons = [Button(button: firstButton), Button(button: secondButton), Button(button: thirdButton)]
        
        for button in buttons {
            button.buttonsRoundedUp()
            button.buttonsAddShadow()
        }
        
        self.moodLabel.text = self.selectedMood?.toString()
        self.moodIcon.image = self.selectedMood?.toIcon()
        self.dateLabel.text = self.date
        
    }

    @IBAction func firstButtonTouchUp(_ sender: UIButton) {
        pushToOnboardingWrite1ViewController(
            sentence: Sentence(
                author: self.firstAuthorLabel.text,
                bookTitle: self.firstBookTitleLabel.text,
                publisher: self.firstPublisherLabel.text,
                sentence: self.firstSentenceLabel.text
            )
        )
    }
    
    @IBAction func secondButtonTouchUp(_ sender: UIButton) {
        pushToOnboardingWrite1ViewController(
            sentence: Sentence(
                author: self.secondAuthorLabel.text,
                bookTitle: self.secondBookTitleLabel.text,
                publisher: self.secondPublisherLabel.text,
                sentence: self.secondSentenceLabel.text
            )
        )
    }
    @IBAction func thirdButtonTouchUp(_ sender: UIButton) {
        pushToOnboardingWrite1ViewController(
            sentence: Sentence(
                author: self.thirdAuthorLabel.text,
                bookTitle: self.thirdBookTitleLabel.text,
                publisher: self.thirdPublisherLabel.text,
                sentence: self.thirdSentenceLabel.text
            )
        )
    }
    
    func pushToOnboardingWrite1ViewController(sentence: Sentence) {
        
        guard let onboardingWrite1ViewController = self.storyboard?.instantiateViewController(identifier: Constants.Identifier.onboardingWrite1ViewController) as? OnboardingWrite1ViewController else { return }
        
        onboardingWrite1ViewController.selectedSentence = sentence 
        
        self.navigationController?.pushViewController(onboardingWrite1ViewController, animated: true)
        
    }
}
