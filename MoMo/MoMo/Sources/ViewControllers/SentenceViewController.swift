//
//  OnboardingSentenceViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/07.
//

import UIKit

struct MoodSentence {
    var author: String
    var bookTitle: String
    var publisher: String
    var sentence: String
}

class SentenceViewController: UIViewController {
    
    // MARK: - @IBOutlet Properties

    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    
    @IBOutlet weak var infoLabel: UILabel!
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
    
    @IBOutlet weak var animateImage: UIImageView!
    @IBOutlet weak var animateImageTop: NSLayoutConstraint!
    @IBOutlet weak var animateImageBottom: NSLayoutConstraint!
    
    // MARK: - Properties
    
    private var buttons: [Button] = []
    var selectedMood: Mood?
    var date: String?
    let defaultInfo: String = "감정과 어울리는 문장을\n매일 3개씩 소개해드릴게요"
    let defaultSentence: MoodSentence = MoodSentence(
        author: "김모모",
        bookTitle: "모모책",
        publisher: "모모출판사",
        sentence: "모모 사랑해요"
    )
    let shadowOffsetButton: CGSize = CGSize(width: 4, height: 4)
    var firstSentence: MoodSentence?
    var secondSentence: MoodSentence?
    var thirdSentence: MoodSentence?
    
    // false일 때 upload
    var changeUsage: Bool = false
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true

        self.buttons = [
            Button(button: firstButton, shadowOffset: shadowOffsetButton),
            Button(button: secondButton, shadowOffset: shadowOffsetButton),
            Button(button: thirdButton, shadowOffset: shadowOffsetButton)
        ]
        
        for button in buttons {
            button.buttonsRoundedUp()
            button.buttonsAddShadow()
        }
        
        self.infoLabel.text = self.defaultInfo
        
        self.moodLabel.text = self.selectedMood?.toString()
        self.moodIcon.image = self.selectedMood?.toIcon()
        self.dateLabel.text = self.date
        
        self.getSentenceDataFromAPI(completion: setSentenceLabel)
        
        self.hideButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hideNavigationButton()
        self.hideimage()
        self.showButtonsWithAnimation()
    }
    
    // MARK: - Functions
    
    func getSentenceDataFromAPI(completion: @escaping () -> Void) {
        
        // 네트워크 통신으로 받아와야 할 부분
        self.firstSentence = MoodSentence(
            author: "구병모",
            bookTitle: "파과",
            publisher: "위즈덤 하우스",
            sentence: "\"우드스탁!\" 그 애는 우리 둘만 있을 땐 나를 꼭 우드스탁이라고 불렀다. 시간이 지날수록 그 호칭은 나를 꽤나 들뜨게 했다."
        )
        
        self.secondSentence = MoodSentence(
            author: "구병모",
            bookTitle: "파과",
            publisher: "위즈덤 하우스",
            sentence: "\"우드스탁!\" 그 애는 우리 둘만 있을 땐 나를 꼭 우드스탁이라고 불렀다. 시간이 지날수록 그 호칭은 나를 꽤나 들뜨게 했다."
        )
        
        self.thirdSentence = MoodSentence(
            author: "구병모",
            bookTitle: "파과",
            publisher: "위즈덤 하우스",
            sentence: "\"우드스탁!\" 그 애는 우리 둘만 있을 땐 나를 꼭 우드스탁이라고 불렀다. 시간이 지날수록 그 호칭은 나를 꽤나 들뜨게 했다."
        )
        
        DispatchQueue.main.async {
            completion()
        }
        
    }
    
    func setSentenceLabel() {
        self.firstAuthorLabel.text = self.firstSentence?.author
        self.firstBookTitleLabel.text = self.getFormattedBookTitle(self.firstSentence?.bookTitle)
        self.firstPublisherLabel.text = self.getFormattedPublisher(self.firstSentence?.publisher)
        self.firstSentenceLabel.text = self.firstSentence?.sentence
        
        self.secondAuthorLabel.text = self.secondSentence?.author
        self.secondBookTitleLabel.text = self.getFormattedBookTitle(self.secondSentence?.bookTitle)
        self.secondPublisherLabel.text = self.getFormattedPublisher(self.secondSentence?.publisher)
        self.secondSentenceLabel.text = self.secondSentence?.sentence
        
        self.thirdAuthorLabel.text = self.thirdSentence?.author
        self.thirdBookTitleLabel.text = self.getFormattedBookTitle(self.thirdSentence?.bookTitle)
        self.thirdPublisherLabel.text = self.getFormattedPublisher(self.thirdSentence?.publisher)
        self.thirdSentenceLabel.text = self.thirdSentence?.sentence
    }
    
    func getFormattedBookTitle(_ bookTitle: String?) -> String {
        return "<\(bookTitle ?? self.defaultSentence.bookTitle)>"
    }
    
    func getFormattedPublisher(_ publisher: String?) -> String {
        return "(\(publisher ?? self.defaultSentence.publisher))"
    }
    
    @IBAction func firstButtonTouchUp(_ sender: UIButton) {
        if changeUsage {
            pushToOnboardingWriteViewController(
                sentence: self.firstSentence ?? self.defaultSentence
            )
        } else {
            pushToDiaryWriteViewController(self.dateLabel.text ?? "",
                                           self.moodLabel.text ?? "",
                                           self.moodIcon.image ?? UIImage(),
                                           self.firstAuthorLabel.text ?? "",
                                           self.firstBookTitleLabel.text ?? "",
                                           self.firstPublisherLabel.text ?? "",
                                           self.firstSentenceLabel.text ?? "")        }
    }
    
    @IBAction func secondButtonTouchUp(_ sender: UIButton) {
        if changeUsage {
            pushToOnboardingWriteViewController(
                sentence: self.firstSentence ?? self.defaultSentence
            )
        } else {
            pushToDiaryWriteViewController(self.dateLabel.text ?? "",
                                           self.moodLabel.text ?? "",
                                           self.moodIcon.image ?? UIImage(),
                                           self.secondAuthorLabel.text ?? "",
                                           self.secondBookTitleLabel.text ?? "",
                                           self.secondPublisherLabel.text ?? "",
                                           self.secondSentenceLabel.text ?? "")
        }
    }
    @IBAction func thirdButtonTouchUp(_ sender: UIButton) {
        if changeUsage {
            pushToOnboardingWriteViewController(
                sentence: self.firstSentence ?? self.defaultSentence
            )
        } else {
            pushToDiaryWriteViewController(self.dateLabel.text ?? "",
                                           self.moodLabel.text ?? "",
                                           self.moodIcon.image ?? UIImage(),
                                           self.thirdAuthorLabel.text ?? "",
                                           self.thirdBookTitleLabel.text ?? "",
                                           self.thirdPublisherLabel.text ?? "",
                                           self.thirdSentenceLabel.text ?? "")
        }
    }
    
    func pushToOnboardingWriteViewController(sentence: MoodSentence) {
        
        guard let onboardingWriteViewController = self.storyboard?.instantiateViewController(identifier: Constants.Identifier.onboardingWriteViewController) as? OnboardingWriteViewController else { return }
        
        onboardingWriteViewController.selectedSentence = sentence
        onboardingWriteViewController.selectedMood = self.selectedMood
        
        self.navigationController?.pushViewController(onboardingWriteViewController, animated: true)
        
    }
    
    func pushToDiaryWriteViewController(_ date: String,
                                        _ mood: String,
                                        _ moodImage: UIImage,
                                        _ author: String,
                                        _ book: String,
                                        _ publisher: String,
                                        _ sentence: String){
        let writeStorybaord = UIStoryboard(name: Constants.Name.diaryWriteStoryboard, bundle: nil)
        guard let uploadWriteViewController = writeStorybaord.instantiateViewController(identifier: Constants.Identifier.diaryWriteViewController) as? DiaryWriteViewController else {
            return
        }
        uploadWriteViewController.date = date
        uploadWriteViewController.emotionOriginalImage = moodImage
        uploadWriteViewController.emotion = mood
        uploadWriteViewController.author = author
        uploadWriteViewController.book = book
        uploadWriteViewController.publisher = publisher
        uploadWriteViewController.quote = sentence
        self.navigationController?.pushViewController(uploadWriteViewController, animated: true)
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
    
    func hideNavigationButton() {
            if !self.changeUsage {
                let rightButton = UIBarButtonItem(image: Constants.Design.Image.btnCloseBlack, style: .plain, target: self, action: #selector(touchCloseButton))
                self.navigationItem.rightBarButtonItems = [rightButton]
                let leftButton = UIBarButtonItem(image: Constants.Design.Image.btnBackBlack, style: .plain, target: self, action: #selector(touchBackButton))
                leftButton.tintColor = .black
                self.navigationItem.leftBarButtonItems = [leftButton]
            }
        }
    
    func hideimage() {
        if changeUsage {
            animateImage.isHidden = true
        } else {
            UIView.animate(withDuration: 1.0, animations: {
                self.animateImage.transform = CGAffineTransform(translationX: 0, y: 30)
            })
    
        }
    }
    
    @objc func touchCloseButton() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
