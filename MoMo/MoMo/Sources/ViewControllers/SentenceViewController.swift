//
//  OnboardingSentenceViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/07.
//

import UIKit

enum SentenceViewUsage: Int {
    case onboarding = 0, upload
}

enum SentenceCardUsage: Int {
    case first = 0, second, third
}

typealias SentenceCard = (author: UILabel, bookTitle: UILabel, publisher: UILabel, sentence: UILabel)

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
    
    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var infoLabelVerticalSpacingContraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var date: String?
    var selectedMood: AppEmotion?
    var sentenveViewUsage: SentenceViewUsage = .onboarding
    private let shadowOffsetButton: CGSize = CGSize(width: 4, height: 4)
    private let infoLabelVerticalSpacing: CGFloat = 66
    private var buttons: [MoodButton] = []
    private var sentences: [SentenceCardUsage: AppSentence] = [:]
    private var sentenceCards: [SentenceCardUsage: SentenceCard] = [:]
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeSentenceViewController()
        self.initializeNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showButtonsWithAnimation()
        
        switch self.sentenveViewUsage {
        case .onboarding:
            return
        case .upload:
            self.showImagesWithAnimation()
        }
    }
    
    // MARK: - Functions
    
    private func initializeSentenceViewController() {
        
        self.sentences = [
            .first: AppSentence(id: nil, author: "", bookTitle: "", publisher: "", sentence: ""),
            .second: AppSentence(id: nil, author: "", bookTitle: "", publisher: "", sentence: ""),
            .third: AppSentence(id: nil, author: "", bookTitle: "", publisher: "", sentence: "")
        ]
        
        self.sentenceCards = [
            .first: (author: self.firstAuthorLabel, bookTitle: self.firstBookTitleLabel, publisher: self.firstPublisherLabel, sentence: self.firstSentenceLabel),
            .second: (author: self.secondAuthorLabel, bookTitle: self.secondBookTitleLabel, publisher: self.secondPublisherLabel, sentence: self.secondSentenceLabel),
            .third: (author: self.thirdAuthorLabel, bookTitle: self.thirdBookTitleLabel, publisher: self.thirdPublisherLabel, sentence: self.thirdSentenceLabel)
        ]
        
        self.updateSentenceLabel()
        self.initializeButtons()
        self.moodLabel.text = self.selectedMood?.toString()
        self.moodIcon.image = self.selectedMood?.toIcon()
        self.dateLabel.text = self.date
        guard let emotionId = self.selectedMood?.rawValue else { return }
        
        switch self.sentenveViewUsage {
        case .onboarding:
            self.infoLabel.text = "감정과 어울리는 문장을\n매일 3개씩 소개해드릴게요"
            self.infoLabelVerticalSpacingContraint.constant = self.infoLabelVerticalSpacing
            self.hideImages()
            self.getOnboardingSentenceWithAPI(emotionId: emotionId, completion: updateSentenceLabel)
        case .upload:
            self.infoLabel.text = "마음에 파동이\n이는 문장을 만나보세요"
            self.getSentencesWithAPI(emotionId: String(emotionId), userId: String(APIConstants.userId), completion: updateSentenceLabel)
        }
    }
    
    private func initializeNavigationBar() {
        self.navigationItem.hidesBackButton = true
        
        switch self.sentenveViewUsage {
        case .onboarding:
            return
        case .upload:
            self.addNavigationRightButton()
            self.addNavigationLeftButton()
        }
    }
    
    private func initializeButtons() {
        self.buttons = [
            MoodButton(button: firstButton, shadowOffset: shadowOffsetButton),
            MoodButton(button: secondButton, shadowOffset: shadowOffsetButton),
            MoodButton(button: thirdButton, shadowOffset: shadowOffsetButton)
        ]
        
        for button in buttons {
            button.buttonsRoundedUp()
            button.buttonsAddShadow()
        }
        
        self.hideButtons()
    }
    
    private func updateSentenceLabel() {
        for idx in 0...2 {
            guard let usage: SentenceCardUsage = SentenceCardUsage.init(rawValue: idx) else { return }
            guard let sentence = self.sentences[usage] else { return }
            guard let sentenceCard = self.sentenceCards[usage] else { return }
            
            sentenceCard.author.attributedText = sentence.author.textSpacing()
            sentenceCard.bookTitle.attributedText = sentence.bookTitle.isEmpty ? sentence.bookTitle : "<\(sentence.bookTitle)>".textSpacing()
            sentenceCard.publisher.attributedText = sentence.publisher.isEmpty ? sentence.publisher : "(\(sentence.publisher))".textSpacing()
            sentenceCard.sentence.attributedText = sentence.sentence.textSpacing()
        }
    }
    
    private func touchBotton(sentence: AppSentence) {
        switch self.sentenveViewUsage {
        case .onboarding:
            pushToOnboardingWriteViewController(sentence: sentence)
        case .upload:
            guard let mood = selectedMood, let date = self.dateLabel.text else { return }
            pushToDiaryWriteViewController(date: date, mood: mood, sentence: sentence)
        }
    }
    
    @IBAction func touchFirstButton(_ sender: UIButton) {
        guard let firstSentence = self.sentences[.first] else { return }
        guard !firstSentence.author.isEmpty, !firstSentence.bookTitle.isEmpty, !firstSentence.sentence.isEmpty else { return }
        self.touchBotton(sentence: firstSentence)
    }
    
    @IBAction func touchSecondButton(_ sender: UIButton) {
        guard let secondSentence = self.sentences[.second] else { return }
        guard !secondSentence.author.isEmpty, !secondSentence.bookTitle.isEmpty, !secondSentence.sentence.isEmpty else { return }
        self.touchBotton(sentence: secondSentence)
    }
    
    @IBAction func touchThirdButton(_ sender: UIButton) {
        guard let thirdSentence = self.sentences[.third] else { return }
        guard !thirdSentence.author.isEmpty, !thirdSentence.bookTitle.isEmpty, !thirdSentence.sentence.isEmpty else { return }
        self.touchBotton(sentence: thirdSentence)
    }
    
    private func pushToOnboardingWriteViewController(sentence: AppSentence) {
        
        guard let onboardingWriteViewController = self.storyboard?.instantiateViewController(identifier: Constants.Identifier.onboardingWriteViewController) as? OnboardingWriteViewController else { return }
        
        onboardingWriteViewController.selectedSentence = sentence
        onboardingWriteViewController.selectedMood = self.selectedMood
        
        self.navigationController?.pushViewController(onboardingWriteViewController, animated: true)
        
    }
    
    private func pushToDiaryWriteViewController(date: String, mood: AppEmotion, sentence: AppSentence) {
        let diaryWriteStoryboard = UIStoryboard(name: Constants.Name.diaryWriteStoryboard, bundle: nil)
        guard let diaryWriteViewController = diaryWriteStoryboard.instantiateViewController(identifier: Constants.Identifier.diaryWriteViewController) as? DiaryWriteViewController else {
            return
        }
        let diaryInfo = AppDiary(
            date: AppDate(formattedDate: date, with: ". "),
            mood: mood,
            depth: nil,
            sentence: sentence,
            diary: nil
        )
        diaryWriteViewController.diaryInfo = diaryInfo
        diaryWriteViewController.isFromDiary = false
        
        self.navigationController?.pushViewController(diaryWriteViewController, animated: true)
    }
    
    private func hideButtons() {
        for button in self.buttons {
            button.button?.alpha = 0.0
        }
    }
    
    private func hideImages() {
        self.circleImageView.alpha = 0.0
    }
    
    private func showButtonsWithAnimation() {
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
    
    private func showImagesWithAnimation() {
        UIView.animate(
            withDuration: 1.0,
            animations: {
                self.circleImageView.alpha = 1.0
                self.circleImageView.transform = CGAffineTransform(translationX: 0, y: 30)
            }
        )
    }
    
    private func addNavigationRightButton() {
        let rightButton = UIBarButtonItem(image: Constants.Design.Image.btnCloseBlack, style: .plain, target: self, action: #selector(touchCloseButton))
        self.navigationItem.rightBarButtonItems = [rightButton]
    }
    
    private func addNavigationLeftButton() {
        let leftButton = UIBarButtonItem(image: Constants.Design.Image.btnBackBlack, style: .plain, target: self, action: #selector(touchBackButton))
        leftButton.tintColor = .black
        self.navigationItem.leftBarButtonItems = [leftButton]
    }
    
    private func popToHomeViewController() {
        guard let homeViewController = self.navigationController?.viewControllers.filter({$0 is HomeViewController}).first! as? HomeViewController else {
            return
        }
        self.navigationController?.popToViewController(homeViewController, animated: true)
    }
    
    @objc func touchCloseButton() {
        self.popToHomeViewController()
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - APIServices

extension SentenceViewController {
    
    private func getSentencesWithAPI(emotionId: String, userId: String, completion: @escaping () -> Void) {
        SentencesService.shared.getSentences(emotionId: emotionId, userId: userId) { networkResult in
            switch networkResult {
            case .success(let data):
                if let serverData = data as? [Sentence] {
                    for idx in 0...2 {
                        guard let usage = SentenceCardUsage.init(rawValue: idx) else { return }
                        self.sentences[usage] = AppSentence(id: serverData[idx].id, author: serverData[idx].writer, bookTitle: serverData[idx].bookName, publisher: serverData[idx].publisher, sentence: serverData[idx].contents)
                    }
                    
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            case .requestErr(let errorMessage):
                print(errorMessage)
            case .pathErr:
                print("pathErr in getSentencesWithAPI")
            case .serverErr:
                print("serverErr in getSentencesWithAPI")
            case .networkFail:
                print("networkFail in getSentencesWithAPI")
            }
        }
    }
    
    private func getOnboardingSentenceWithAPI(emotionId: Int, completion: @escaping () -> Void) {
        OnboardingService.shared.getOnboardingWithEmotionId(emotionId: emotionId) { (result) in
            switch result {
            case .success(let data):
                if let sentences = data as? OnboardingSentence {
                    
                    self.sentences[.first] = AppSentence(id: nil, author: sentences.sentence01.writer, bookTitle: sentences.sentence01.bookName, publisher: sentences.sentence01.publisher, sentence: sentences.sentence01.contents)
                    
                    self.sentences[.second] = AppSentence(id: nil, author: sentences.sentence02.writer, bookTitle: sentences.sentence02.bookName, publisher: sentences.sentence02.publisher, sentence: sentences.sentence02.contents)
                    
                    self.sentences[.third] = AppSentence(id: nil, author: sentences.sentence03.writer, bookTitle: sentences.sentence03.bookName, publisher: sentences.sentence03.publisher, sentence: sentences.sentence03.contents)
                    
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            case .requestErr(let errorMessage):
                print(errorMessage)
            case .pathErr:
                print("pathErr in getOnboardingSentenceWithAPI")
            case .serverErr:
                print("serverErr in getOnboardingSentenceWithAPI")
            case .networkFail:
                print("networkFail in getOnboardingSentenceWithAPI")
            }
        }
    }
}
