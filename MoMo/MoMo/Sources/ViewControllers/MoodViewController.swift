//
//  OnboardingMoodViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/07.
//

import UIKit

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
    
    // MARK: - Properties
    
    let info: String = "먼저 오늘의\n감정을 선택해 주세요"
    var changeUsage: Bool = false // false는 Upload에서 사용
    var listNoDiary: Bool = false
    private var buttons: [MoodButton] = []
    private var modalView: UploadModalViewController?
    private var currentDate: AppDate?
    private var selectedDate: AppDate?

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeMoodViewController()
        
        guard let currentDate = self.currentDate else { return }
        
        self.getDiariesWithAPI(userID: String(APIConstants.userId),
                               year: currentDate.getYearToString(),
                               month: currentDate.getMonthToString(),
                               order: "filter",
                               day: currentDate.getDay(),
                               emotionID: nil,
                               depth: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideCalendarButton()
        self.hideNavigationButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showButtonsWithAnimation()
    }
    
    // MARK: - Functions
    
    func initializeMoodViewController() {
        
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
        self.infoLabel.text = self.info
        self.currentDate = AppDate()
        self.selectedDate = AppDate()
        self.modalView = UploadModalViewController()
        self.modalView?.uploadModalDataDelegate = self
    }
    
    func initializeDateLabel(recentDate: String, verifyToday: Bool) {
        if !verifyToday {
            self.dateLabel.text = self.currentDate?.getFormattedDateAndWeekday(with: ". ")
            self.selectedDate = self.currentDate
        } else {
            let date = AppDate(serverDate: recentDate)
            self.selectedDate = date
            self.dateLabel.text = date.getFormattedDateAndWeekday(with: ". ")
            if listNoDiary {
                self.presentUploadModalView(year: date.getYear(), month: date.getMonth(), day: date.getDay())
            }
        }
    }
    
    func hideNavigationButton() {
        if !self.changeUsage {
            let rightButton = UIBarButtonItem(image: Constants.Design.Image.btnCloseBlack, style: .plain, target: self, action: #selector(touchCloseButton))
            self.navigationItem.rightBarButtonItems = [rightButton]
            self.navigationItem.hidesBackButton = true
        }
    }
    
    func hideCalendarButton() {
        if self.changeUsage {
            self.calendarButton.isHidden = true
        }
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
    
    func presentUploadModalView(year: Int, month: Int, day: Int) {
        guard let modalView = self.modalView else { return }
        modalView.year = year
        modalView.month = month
        modalView.day = day
        modalView.verifyMood = true
        modalView.modalPresentationStyle = .custom
        modalView.transitioningDelegate = self
        self.present(modalView, animated: true, completion: nil)
    }
    
    func pushToOnboardingSentenceViewController(mood: AppEmotion) {
        guard let sentenceViewController = self.storyboard?.instantiateViewController(identifier: Constants.Identifier.sentenceViewController) as? SentenceViewController else { return }
        
        sentenceViewController.selectedMood = mood
        sentenceViewController.date = self.dateLabel.text
        sentenceViewController.changeUsage = self.changeUsage
        
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
        pushToOnboardingSentenceViewController(mood: AppEmotion.love)
    }
    
    @IBAction func touchHappyButton(_ sender: UIButton) {
        pushToOnboardingSentenceViewController(mood: AppEmotion.happy)
    }
    
    @IBAction func touchConsoleButton(_ sender: UIButton) {
        pushToOnboardingSentenceViewController(mood: AppEmotion.console)
    }
    
    @IBAction func touchAngryButton(_ sender: UIButton) {
        pushToOnboardingSentenceViewController(mood: AppEmotion.angry)
    }
    
    @IBAction func touchSadButton(_ sender: UIButton) {
        pushToOnboardingSentenceViewController(mood: AppEmotion.sad)
    }
    
    @IBAction func touchBoredButton(_ sender: UIButton) {
        pushToOnboardingSentenceViewController(mood: AppEmotion.bored)
    }
    
    @IBAction func touchMemoryButton(_ sender: UIButton) {
        pushToOnboardingSentenceViewController(mood: AppEmotion.memory)
    }
    
    @IBAction func touchDailyButton(_ sender: UIButton) {
        pushToOnboardingSentenceViewController(mood: AppEmotion.daily)
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
    func getDiariesWithAPI(userID: String,
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
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    func getDiaryRecentWithAPI(userID: String, verifyToday: Bool) {
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
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
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
