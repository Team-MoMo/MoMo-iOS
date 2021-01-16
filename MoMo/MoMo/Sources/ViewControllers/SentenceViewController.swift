//
//  OnboardingSentenceViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/07.
//

import UIKit

struct MoodSentence {
    var id: Int?
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
    
    var receivedData: [Sentence] = []
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
        
        if changeUsage {
            self.getSentenceDataFromAPI(emotionId: self.selectedMood?.rawValue ?? 1, completion: setSentenceLabel)
        } else {
            self.connectServer(emotionId: String(self.selectedMood?.rawValue ?? 1), userId: String(APIConstants.userId))
        }
        
        
        self.hideButtons()
        
        self.hideimage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hideNavigationButton()
        self.showButtonsWithAnimation()
    }
    
    // MARK: - Functions
    
    func connectServer(emotionId: String, userId: String) {
        SentencesService.shared.getSentences(emotionId: emotionId, userId: userId) {
            (networkResult) -> (Void) in
            switch networkResult {

            case .success(let data):
                if let serverData = data as? [Sentence] {
                    self.receivedData = serverData
                    self.setReceivedSentenceLabel()
                }
                
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
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
    
    func setReceivedSentenceLabel() {
        self.firstAuthorLabel.text = self.receivedData[0].writer
        self.firstBookTitleLabel.text = self.receivedData[0].bookName
        self.firstPublisherLabel.text = self.receivedData[0].publisher
        self.firstSentenceLabel.text = self.receivedData[0].contents
            
        self.secondAuthorLabel.text = self.receivedData[1].writer
        self.secondBookTitleLabel.text = self.receivedData[1].bookName
        self.secondPublisherLabel.text = self.receivedData[1].publisher
        self.secondSentenceLabel.text = self.receivedData[1].contents
            
        self.thirdAuthorLabel.text = self.receivedData[2].writer
        self.thirdBookTitleLabel.text = self.receivedData[2].bookName
        self.thirdPublisherLabel.text = self.receivedData[2].publisher
        self.thirdSentenceLabel.text = self.receivedData[2].contents
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
            guard let mood = selectedMood else {
                return
            }
            pushToDiaryWriteViewController(self.dateLabel.text ?? "",
                                           mood,
                                           receivedData[0])
        }
    }
    
    @IBAction func secondButtonTouchUp(_ sender: UIButton) {
        if changeUsage {
            pushToOnboardingWriteViewController(
                sentence: self.secondSentence ?? self.defaultSentence
            )
        } else {
            guard let mood = selectedMood else {
                return
            }
            pushToDiaryWriteViewController(self.dateLabel.text ?? "",
                                           mood,
                                           receivedData[1])
        }
    }
    @IBAction func thirdButtonTouchUp(_ sender: UIButton) {
        if changeUsage {
            pushToOnboardingWriteViewController(
                sentence: self.thirdSentence ?? self.defaultSentence
            )
        } else {
            guard let mood = selectedMood else {
                return
            }
            pushToDiaryWriteViewController(self.dateLabel.text ?? "",
                                           mood,
                                           receivedData[2])
        }
    }
    
    func pushToOnboardingWriteViewController(sentence: MoodSentence) {
        
        guard let onboardingWriteViewController = self.storyboard?.instantiateViewController(identifier: Constants.Identifier.onboardingWriteViewController) as? OnboardingWriteViewController else { return }
        
        onboardingWriteViewController.selectedSentence = sentence
        onboardingWriteViewController.selectedMood = self.selectedMood
        
        self.navigationController?.pushViewController(onboardingWriteViewController, animated: true)
        
    }
    
    func pushToDiaryWriteViewController(_ date: String,
                                        _ mood: Mood,
                                        _ sentence: Sentence){
        let writeStorybaord = UIStoryboard(name: Constants.Name.diaryWriteStoryboard, bundle: nil)
        guard let uploadWriteViewController = writeStorybaord.instantiateViewController(identifier: Constants.Identifier.diaryWriteViewController) as? DiaryWriteViewController else {
            return
        }
        uploadWriteViewController.date = date
        uploadWriteViewController.mood = mood
        uploadWriteViewController.sentence = sentence
        uploadWriteViewController.isFromDiary = false
        
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

// API

extension SentenceViewController {
    
    func getSentenceDataFromAPI(emotionId: Int, completion: @escaping () -> Void) {
        
        OnboardingService.shared.getOnboardingWithEmotionId(emotionId: emotionId) { (result) in
            switch(result) {
            case .success(let data):
                if let sentences = data as? OnboardingSentence {
                    
                    self.firstSentence = MoodSentence(
                        author: sentences.sentence01.writer,
                        bookTitle: sentences.sentence01.bookName,
                        publisher: sentences.sentence01.publisher,
                        sentence: sentences.sentence01.contents
                    )
                    
                    self.secondSentence = MoodSentence(
                        author: sentences.sentence02.writer,
                        bookTitle: sentences.sentence02.bookName,
                        publisher: sentences.sentence02.publisher,
                        sentence: sentences.sentence02.contents
                    )
                    
                    self.thirdSentence = MoodSentence(
                        author: sentences.sentence03.writer,
                        bookTitle: sentences.sentence03.bookName,
                        publisher: sentences.sentence03.publisher,
                        sentence: sentences.sentence03.contents
                    )
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            case .requestErr(let errorMessage):
                print(errorMessage)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}
