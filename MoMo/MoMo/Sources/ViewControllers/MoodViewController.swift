//
//  OnboardingMoodViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/07.
//

import UIKit

enum MoodViewUsage: Int {
    case onboarding = 0, upload
}

class MoodViewController: UIViewController {
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var loveButton: UIButton!
    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var consoleButton: UIButton!
    @IBOutlet weak var angryButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    @IBOutlet weak var boredButton: UIButton!
    @IBOutlet weak var memoryButton: UIButton!
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var infoLabelVerticalSpacingContraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var moodViewUsage: MoodViewUsage = .onboarding
    private var buttons: [MoodButton] = []
    private var modalView: UploadModalViewController?
    private var currentDate: AppDate?
    private var selectedDate: AppDate?
    private let infoLabelVerticalSpacing: CGFloat = 66

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeMoodViewController()
        self.initializeNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showButtonsWithAnimation()
    }
    
    // MARK: - Functions
    
    private func initializeMoodViewController() {
        
        self.currentDate = AppDate()
        self.selectedDate = AppDate()
        self.modalView = UploadModalViewController()
        self.modalView?.uploadModalDataDelegate = self
        
        self.initializeButtons()
        
        switch self.moodViewUsage {
        case .onboarding:
            self.infoLabel.attributedText = "먼저 오늘의\n감정을 선택해 주세요".textSpacing()
            self.infoLabelVerticalSpacingContraint.constant = self.infoLabelVerticalSpacing
            self.dateLabel.attributedText = self.currentDate?.getFormattedDateAndWeekday(with: ". ").textSpacing()
            self.hideCalendarButton()
        case .upload:
            self.infoLabel.attributedText = "오늘의\n감정은 어땠나요?".textSpacing()
            guard let currentDate = self.currentDate else { return }
            self.getDiariesWithAPI(
                userID: String(APIConstants.userId),
                year: currentDate.getYearToString(),
                month: currentDate.getMonthToString(),
                order: "filter",
                day: currentDate.getDay(),
                emotionID: nil,
                depth: nil
            )
        }
    }
    
    private func initializeButtons() {
        self.buttons = [
            MoodButton(button: self.loveButton),
            MoodButton(button: self.happyButton),
            MoodButton(button: self.consoleButton),
            MoodButton(button: self.angryButton),
            MoodButton(button: self.sadButton),
            MoodButton(button: self.boredButton),
            MoodButton(button: self.memoryButton),
            MoodButton(button: self.dailyButton)
        ]
        
        for button in self.buttons {
            button.buttonsRoundedUp()
            button.buttonsAddShadow()
        }
        
        self.hideButtons()
    }
    
    private func initializeNavigationBar() {
        self.hideNavigationBackButton()
        
        switch self.moodViewUsage {
        case .onboarding:
            return
        case .upload:
            self.addNavigationRightButton()
        }
    }
    
    private func initializeDateLabel(recentDate: String, verifyToday: Bool) {
        if !verifyToday {
            self.dateLabel.attributedText = self.currentDate?.getFormattedDateAndWeekday(with: ". ").textSpacing()
            self.selectedDate = self.currentDate
        } else {
            let date = AppDate(serverDate: recentDate)
            self.selectedDate = date
            self.presentUploadModalView(year: date.getYear(), month: date.getMonth(), day: date.getDay())
            self.dateLabel.attributedText = date.getFormattedDateAndWeekday(with: ". ").textSpacing()
        }
    }
    
    private func addNavigationRightButton() {
        let rightButton = UIBarButtonItem(image: Constants.Design.Image.btnCloseBlack, style: .plain, target: self, action: #selector(touchCloseButton))
        self.navigationItem.rightBarButtonItems = [rightButton]
    }
    
    private func hideNavigationBackButton() {
        self.navigationItem.hidesBackButton = true
    }
    
    private func hideCalendarButton() {
        self.calendarButton.isHidden = true
    }
    
    private func hideButtons() {
        for button in self.buttons {
            button.button?.alpha = 0.0
        }
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
    
    private func presentUploadModalView(year: Int, month: Int, day: Int) {
        guard let modalView = self.modalView else { return }
        modalView.year = year
        modalView.month = month
        modalView.day = day
        modalView.verifyMood = true
        modalView.modalPresentationStyle = .custom
        modalView.transitioningDelegate = self
        self.present(modalView, animated: true, completion: nil)
    }
    
    private func pushToSentenceViewController(mood: AppEmotion) {
        guard let sentenceViewController = self.storyboard?.instantiateViewController(identifier: Constants.Identifier.sentenceViewController) as? SentenceViewController else { return }
        
        sentenceViewController.selectedMood = mood
        sentenceViewController.date = self.dateLabel.text
        
        switch self.moodViewUsage {
        case .onboarding:
            sentenceViewController.sentenveViewUsage = .onboarding
        case .upload:
            sentenceViewController.sentenveViewUsage = .upload
        }
        
        self.navigationController?.pushViewController(sentenceViewController, animated: true)
        
    }
    
    @objc func touchCloseButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func touchCalendarButton(_ sender: Any) {
        guard let selectedDate = self.selectedDate else { return }
        self.presentUploadModalView(year: selectedDate.getYear(), month: selectedDate.getMonth(), day: selectedDate.getDay())
    }
    
    @IBAction func touchLoveButton(_ sender: UIButton) {
        pushToSentenceViewController(mood: AppEmotion.love)
    }
    
    @IBAction func touchHappyButton(_ sender: UIButton) {
        pushToSentenceViewController(mood: AppEmotion.happy)
    }
    
    @IBAction func touchConsoleButton(_ sender: UIButton) {
        pushToSentenceViewController(mood: AppEmotion.console)
    }
    
    @IBAction func touchAngryButton(_ sender: UIButton) {
        pushToSentenceViewController(mood: AppEmotion.angry)
    }
    
    @IBAction func touchSadButton(_ sender: UIButton) {
        pushToSentenceViewController(mood: AppEmotion.sad)
    }
    
    @IBAction func touchBoredButton(_ sender: UIButton) {
        pushToSentenceViewController(mood: AppEmotion.bored)
    }
    
    @IBAction func touchMemoryButton(_ sender: UIButton) {
        pushToSentenceViewController(mood: AppEmotion.memory)
    }
    
    @IBAction func touchDailyButton(_ sender: UIButton) {
        pushToSentenceViewController(mood: AppEmotion.daily)
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate

extension MoodViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        UploadModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - UploadModalViewDelegate

extension MoodViewController: UploadModalViewDelegate {
    func passData(_ date: String) {
        self.selectedDate = AppDate(formattedDate: date, with: ". ")
        self.dateLabel.text = date
    }
}

// MARK: - API

extension MoodViewController {
    private func getDiariesWithAPI(
        userID: String,
        year: String,
        month: String,
        order: String,
        day: Int?,
        emotionID: Int?,
        depth: Int?
    ) {
        DiariesService.shared.getDiaries(userId: userID,
                                         year: year,
                                         month: month,
                                         order: order,
                                         day: day,
                                         emotionId: emotionID,
                                         depth: depth) { networkResult in
            switch networkResult {
            case .success(let data):
                if let diary = data as? [Diary] {
                    if diary.count > 0 {
                        self.getDiaryRecentWithAPI(userID: String(APIConstants.userId), verifyToday: true)
                    } else {
                        self.getDiaryRecentWithAPI(userID: String(APIConstants.userId), verifyToday: false)
                    }
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr in getDiariesWithAPI")
            case .serverErr:
                print("serverErr in getDiariesWithAPI")
            case .networkFail:
                print("networkFail in getDiariesWithAPI")
            }
        }
    }
    
    private func getDiaryRecentWithAPI(userID: String, verifyToday: Bool) {
        DiaryRecentService.shared.getDiaryRecent(userId: userID) { networkResult in
            switch networkResult {
            case .success(let data):
                if let recentDate = data as? String {
                    self.initializeDateLabel(recentDate: recentDate, verifyToday: verifyToday)
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr in getDiaryRecentWithAPI")
            case .serverErr:
                print("serverErr in getDiaryRecentWithAPI")
            case .networkFail:
                print("networkFail in getDiaryRecentWithAPI")
            }
        }
    }
}

// MARK: - Button

struct MoodButton {
    
    let button: UIButton?
    let cornerRadius: CGFloat = 12
    var shadowColor: CGColor = UIColor.NavWhite.cgColor
    var shadowOffset: CGSize = CGSize(width: 5, height: 5)
    var shadowOpacity: Float = 0.7
    var shadowRadius: CGFloat = 4.0
    
    func buttonsRoundedUp() {
        self.button?.layer.cornerRadius = self.cornerRadius
        self.button?.clipsToBounds = true
    }
    
    func buttonsAddShadow() {
        self.button?.layer.shadowColor = self.shadowColor
        self.button?.layer.shadowOpacity = self.shadowOpacity
        self.button?.layer.shadowOffset = self.shadowOffset
        self.button?.layer.shadowRadius = self.shadowRadius
        self.button?.layer.masksToBounds = false
    }
    
}
