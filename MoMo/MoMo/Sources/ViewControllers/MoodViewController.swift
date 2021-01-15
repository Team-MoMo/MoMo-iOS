//
//  OnboardingMoodViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/07.
//

import UIKit

enum Mood: Int {
    case love = 1, happy, console, angry, sad, bored, memory, daily
    
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
    
    func toBlueIcon() -> UIImage {
        switch self {
        case .love:
            return Constants.Design.Image.icLove14Blue!
        case .happy:
            return Constants.Design.Image.icHappy14Blue!
        case .console:
            return Constants.Design.Image.icConsole14Blue!
        case .angry:
            return Constants.Design.Image.icAngry14Blue!
        case .sad:
            return Constants.Design.Image.icSad14Blue!
        case .bored:
            return Constants.Design.Image.icBored14Blue!
        case .memory:
            return Constants.Design.Image.icMemory14Blue!
        case .daily:
            return Constants.Design.Image.icDaily14Blue!
        }
    }
    
    func toTypingLabelText() -> String {
        switch self {
        case .love:
            return "새로운 인연이 기대되는 하루였다. "
        case .happy:
            return "삶의 소중함을 느낀 하루였다. "
        case .console:
            return "나를 위한 진한 위로가 필요한 하루였다. "
        case .angry:
            return "끓어오르는 속을 진정시켜야 하는 하루였다. "
        case .sad:
            return "마음이 찌릿하게 아픈 하루였다. "
        case .bored:
            return "눈물이 왈칵 쏟아질 것 같은 하루였다. "
        case .memory:
            return "오래된 기억이 되살아나는 하루였다. "
        case .daily:
            return "평안한 하루가 감사한 날이었다."
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
    
    var today: String = ""
    private var buttons: [Button] = []
    var date: String?
    let defaultInfo: String = "먼저 오늘의\n감정을 선택해 주세요"
    //false == upload모드
    var changeUsage: Bool = false
    var listNoDiary: Bool = false
    var modalView: UploadModalViewController? = nil
    var recentDate: String = ""
    let weekdayArray: [String] = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"]
    var year: Int = 0
    var month: Int = 0
    var day: Int = 0

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
        
        if listNoDiary {
            let date = Date()
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale.current
            
            let formattedDate = dateFormatter.string(from: date)
            today = formattedDate
            let dateArray = formattedDate.split(separator: "-")
            print(today)
            day = Int(dateArray[2])!
            
            checkTodayJournal(userID: String(APIConstants.userId), year: "\(dateArray[0])", month: "\(dateArray[1])", order: "filter", day: day, emotionID: nil, depth: nil)
            listNoDiary.toggle()
        } else {
            self.date = self.getCurrentFormattedDate()
            self.dateLabel.text = self.date
        }
        
        
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
    
    func compareRecentDate(recendDate: String, verifyToday:Bool) {
        let date = recendDate.split(separator: "T")[0]
        

        if !verifyToday {
            let dateArray = self.today.split(separator: "-")
            let dateComponents = NSDateComponents()
            guard let year = Int(dateArray[0]), let month = Int(dateArray[1]), let day = Int(dateArray[2]) else {
                return
            }
            dateComponents.day = day
            dateComponents.month = month
            dateComponents.year = year
            
            self.year = year
            self.month = month
            self.day = day

            guard let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian),
                let date = gregorianCalendar.date(from: dateComponents as DateComponents) else {
                return
            }
            let weekday = gregorianCalendar.component(.weekday, from: date)
            self.dateLabel.text = "\(dateArray[0]). \(dateArray[1]). \(dateArray[2]). \(weekdayArray[weekday-1])"
            
            
        } else {
            let dateArray = date.split(separator: "-")
            let dateComponents = NSDateComponents()
            guard let year = Int(dateArray[0]), let month = Int(dateArray[1]), let day = Int(dateArray[2]) else {
                return
            }
            
            dateComponents.day = day
            dateComponents.month = month
            dateComponents.year = year
            
            self.year = year
            self.month = month
            self.day = day
            
            guard let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian),
                let date = gregorianCalendar.date(from: dateComponents as DateComponents) else {
                return
            }
            let weekday = gregorianCalendar.component(.weekday, from: date)
            self.dateLabel.text = "\(dateArray[0]). \(dateArray[1]). \(dateArray[2]). \(weekdayArray[weekday-1])"
            
            modalView?.year = self.year
            modalView?.month = self.month
            modalView?.day = self.day
            modalView?.verifyMood = true
            modalView?.modalPresentationStyle = .custom
            modalView?.transitioningDelegate = self
            self.present(modalView!, animated: true, completion: nil)
            
        }
    }
    
    func checkTodayJournal(userID: String,
                       year: String,
                       month: String,
                       order: String,
                       day: Int?,
                       emotionID: Int?,
                       depth: Int?) {
        DiariesService.shared.getDiaries(userId: userID,
                                         year: year,
                                         month: month,
                                         order: order,
                                         day: day,
                                         emotionId: emotionID,
                                         depth: depth) {
            (networkResult) -> (Void) in
            switch networkResult {

            case .success(let data):
                if let diary = data as? [Diary] {
                    if diary.count > 0 {
                        self.connectServer(userID: String(APIConstants.userId), verifyToday: true)
                    } else {
                        self.connectServer(userID: String(APIConstants.userId), verifyToday: false)
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
    
    func connectServer(userID: String, verifyToday: Bool) {
        DiaryRecentService.shared.getDiaryRecent(userId: userID) {
            (networkResult) -> (Void) in
            switch networkResult {

            case .success(let data):
                if let recentDate = data as? String {
                    self.recentDate = recentDate
                    self.compareRecentDate(recendDate: self.recentDate, verifyToday: verifyToday)
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
        guard let date = dateLabel.text else {
            return
        }
        let dateArray = date.components(separatedBy: ". ")
        guard let year = Int(dateArray[0]),
              let month = Int(dateArray[1]),
              let day = Int(dateArray[2]) else {
            return
        }
        
        modalView?.year = year
        modalView?.month = month
        modalView?.day = day
        modalView?.verifyMood = true
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
        pushToOnboardingSentenceViewController(mood: Mood.console, usage: changeUsage)
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
    func passData(_ date: String) {
        self.dateLabel.text = date
    }
}
