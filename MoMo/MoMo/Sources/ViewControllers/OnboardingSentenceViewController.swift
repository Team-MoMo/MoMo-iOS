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
    
    // MARK: - @IBOutlet Properties

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
    
    // MARK: - Properties
    
    private var buttons: [Button] = []
    var selectedMood: Mood?
    var date: String?
    let defaultSentence: Sentence = Sentence(
        author: "김모모",
        bookTitle: "모모책",
        publisher: "모모출판사",
        sentence: "모모 사랑해요"
    )
    var firstSentence: Sentence?
    var secondSentence: Sentence?
    var thirdSentence: Sentence?
    
    // MARK: - View Life Cycle
    
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
        
        self.getSentenceDataFromAPI(completion: setSentenceLabel)
    }
    
    // MARK: - Functions
    
    func getSentenceDataFromAPI(completion: @escaping () -> Void) {
        
        // 네트워크 통신으로 받아와야 할 부분
        self.firstSentence = Sentence(
            author: "구병모",
            bookTitle: "파과",
            publisher: "위즈덤 하우스",
            sentence: "\"우드스탁!\" 그 애는 우리 둘만 있을 땐 나를 꼭 우드스탁이라고 불렀다. 시간이 지날수록 그 호칭은 나를 꽤나 들뜨게 했다."
        )
        
        self.secondSentence = Sentence(
            author: "구병모",
            bookTitle: "파과",
            publisher: "위즈덤 하우스",
            sentence: "\"우드스탁!\" 그 애는 우리 둘만 있을 땐 나를 꼭 우드스탁이라고 불렀다. 시간이 지날수록 그 호칭은 나를 꽤나 들뜨게 했다."
        )
        
        self.thirdSentence = Sentence(
            author: "구병모",
            bookTitle: "파과",
            publisher: "위즈덤 하우스",
            sentence: "\"우드스탁!\" 그 애는 우리 둘만 있을 땐 나를 꼭 우드스탁이라고 불렀다. 시간이 지날수록 그 호칭은 나를 꽤나 들뜨게 했다."
        )
        
    }
    
    func setSentenceLabel() {
        self.firstAuthorLabel.text = self.firstSentence?.author
        self.firstBookTitleLabel.text = self.firstSentence?.bookTitle
        self.firstPublisherLabel.text = self.firstSentence?.publisher
        self.firstSentenceLabel.text = self.firstSentence?.sentence
        
        self.secondAuthorLabel.text = self.secondSentence?.author
        self.secondBookTitleLabel.text = self.secondSentence?.bookTitle
        self.secondPublisherLabel.text = self.secondSentence?.publisher
        self.secondSentenceLabel.text = self.secondSentence?.sentence
        
        self.thirdAuthorLabel.text = self.thirdSentence?.author
        self.thirdBookTitleLabel.text = self.thirdSentence?.bookTitle
        self.thirdPublisherLabel.text = self.thirdSentence?.publisher
        self.thirdSentenceLabel.text = self.thirdSentence?.sentence
    }
    
    @IBAction func firstButtonTouchUp(_ sender: UIButton) {
        pushToOnboardingWrite1ViewController(
            sentence: self.firstSentence ?? self.defaultSentence
        )
    }
    
    @IBAction func secondButtonTouchUp(_ sender: UIButton) {
        pushToOnboardingWrite1ViewController(
            sentence: self.secondSentence ?? self.defaultSentence
        )
    }
    @IBAction func thirdButtonTouchUp(_ sender: UIButton) {
        pushToOnboardingWrite1ViewController(
            sentence: self.thirdSentence ?? self.defaultSentence
        )
    }
    
    func pushToOnboardingWrite1ViewController(sentence: Sentence) {
        
        guard let onboardingWriteViewController = self.storyboard?.instantiateViewController(identifier: Constants.Identifier.onboardingWriteViewController) as? OnboardingWriteViewController else { return }
        
        onboardingWriteViewController.selectedSentence = sentence
        
        self.navigationController?.pushViewController(onboardingWriteViewController, animated: true)
        
    }
    
    func hideButtons() {
        for button in self.buttons {
            button.button?.alpha = 0.0
        }
    }
    
    func showButtonsWithAnimation() {
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            animations: {
                for button in self.buttons {
                    button.button?.alpha = 1.0
                }
            }
        )
    }
}
