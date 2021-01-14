//
//  OnboardingMoodViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/07.
//

import UIKit

enum Mood {
    case love, happy, console, angry, sad, bored, memory, daily
    
    func toString() -> String {
        switch self {
        case .love:
            return "사랑"
        case .happy:
            return "행복"
        case .console:
            return "위로"
        case .angry:
            return "화남"
        case .sad:
            return "슬픔"
        case .bored:
            return "우울"
        case .memory:
            return "추억"
        case .daily:
            return "일상"
        }
    }
    
    func toIcon() -> UIImage {
        switch self {
        case .love:
            return Constants.Design.Image.icLove14Black!
        case .happy:
            return Constants.Design.Image.icHappy14Black!
        case .console:
            return Constants.Design.Image.icConsole14Black!
        case .angry:
            return Constants.Design.Image.icAngry14Black!
        case .sad:
            return Constants.Design.Image.icSad14Black!
        case .bored:
            return Constants.Design.Image.icBored14Black!
        case .memory:
            return Constants.Design.Image.icMemory14Black!
        case .daily:
            return Constants.Design.Image.icDaily14Black!
        }
    }
    
    func toWhiteIcon() -> UIImage {
        switch self {
        case .love:
            return Constants.Design.Image.icLove14White!
        case .happy:
            return Constants.Design.Image.icHappy14White!
        case .console:
            return Constants.Design.Image.icConsole14White!
        case .angry:
            return Constants.Design.Image.icAngry14White!
        case .sad:
            return Constants.Design.Image.icSad14White!
        case .bored:
            return Constants.Design.Image.icBored14White!
        case .memory:
            return Constants.Design.Image.icMemory14White!
        case .daily:
            return Constants.Design.Image.icDaily14White!
        }
    }
}

struct Button {
    
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
    
    private var buttons: [Button] = []
    var date: String?
    let defaultInfo: String = "먼저 오늘의\n감정을 선택해 주세요"
    //false == upload모드
    var changeUsage: Bool = false
    var modalView: UploadModalViewController? = nil

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalView = UploadModalViewController()
        self.modalView?.uploadModalDataDelegate = self
        
        self.buttons = [
            Button(button: self.loveButton),
            Button(button: self.happyButton),
            Button(button: self.consoleButton),
            Button(button: self.angryButton),
            Button(button: self.sadButton),
            Button(button: self.boredButton),
            Button(button: self.memoryButton),
            Button(button: self.dailyButton)
        ]
        
        for button in self.buttons {
            button.buttonsRoundedUp()
            button.buttonsAddShadow()
        }
        
        self.hideButtons()
        
        self.infoLabel.text = self.defaultInfo
        self.date = self.getCurrentFormattedDate()
        self.dateLabel.text = self.date
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideCalendarButton()
        hideNavigationButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showButtonsWithAnimation()
    }
    
    // MARK: - Functions
    
    func getCurrentFormattedDate() -> String? {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy. MM. dd. EEEE"
        dateFormatter.locale = Locale.current
        
        let formattedDate = dateFormatter.string(from: date)
        var dateArray = formattedDate.components(separatedBy: ". ")
        let weekday = dateArray.popLast()
        
        dateArray.append(weekdayEnglishToKorean(weekday: weekday ?? "Monday"))
        
        let formattedDateWithKorean = dateArray.joined(separator: ". ")
        
        return formattedDateWithKorean
    }
    
    func weekdayEnglishToKorean(weekday: String) -> String {
        switch weekday {
        case "Monday":
            return "월요일"
        case "Tuesday":
            return "화요일"
        case "Wednesday":
            return "수요일"
        case "Thursday":
            return "목요일"
        case "Friday":
            return "금요일"
        case "Saturday":
            return "토요일"
        case "Sunday":
            return "일요일"
        default:
            return "월요일"
        }
    }
    
    
    @IBAction func touchCalendarButton(_ sender: Any) {
        modalView?.modalPresentationStyle = .custom
        modalView?.transitioningDelegate = self
        self.present(modalView!, animated: true, completion: nil)
    }
    
    @IBAction func loveButtonTouchUp(_ sender: UIButton) {
        pushToOnboardingSentenceViewController(mood: Mood.love, usage: changeUsage)
    }
    
    @IBAction func happyButtonTouchUp(_ sender: UIButton) {
        pushToOnboardingSentenceViewController(mood: Mood.happy, usage: changeUsage)
    }
    
    @IBAction func consoleButtonTouchUp(_ sender: UIButton) {
        pushToOnboardingSentenceViewController(mood: Mood.console,usage: changeUsage)
    }
    
    @IBAction func angryButtonTouchUp(_ sender: UIButton) {
        pushToOnboardingSentenceViewController(mood: Mood.angry, usage: changeUsage)
    }
    
    @IBAction func sadButtonTouchUp(_ sender: UIButton) {
        pushToOnboardingSentenceViewController(mood: Mood.sad, usage: changeUsage)
    }
    
    @IBAction func boredButtonTouchUp(_ sender: UIButton) {
        pushToOnboardingSentenceViewController(mood: Mood.bored, usage: changeUsage)
    }
    
    @IBAction func memoryButtonTouchUp(_ sender: UIButton) {
        pushToOnboardingSentenceViewController(mood: Mood.memory, usage: changeUsage)
    }
    
    @IBAction func dailyButtonTouchUp(_ sender: UIButton) {
        pushToOnboardingSentenceViewController(mood: Mood.daily, usage: changeUsage)
    }
    
    @objc func touchCloseButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func pushToOnboardingSentenceViewController(mood: Mood, usage: Bool) {
        
        guard let sentenceViewController = self.storyboard?.instantiateViewController(identifier: Constants.Identifier.sentenceViewController) as? SentenceViewController else { return }
        
        sentenceViewController.selectedMood = mood
        sentenceViewController.date = self.date
        sentenceViewController.changeUsage = self.changeUsage
        
        self.navigationController?.pushViewController(sentenceViewController, animated: true)
        
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
    
}

extension MoodViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        UploadModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension MoodViewController: UploadModalPassDataDelegate {
    func sendData(_ date: String) {
        self.dateLabel.text = date
    }
}
