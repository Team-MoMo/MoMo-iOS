//
//  DiaryViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/12.
//

import UIKit

class DiaryViewController: UIViewController {
    
    @IBOutlet weak var fish1: UIImageView!
    @IBOutlet weak var fish2: UIImageView!
    @IBOutlet weak var dolphin1: UIImageView!
    @IBOutlet weak var dolphin2: UIImageView!
    @IBOutlet weak var turtle1: UIImageView!
    @IBOutlet weak var turtle2: UIImageView!
    @IBOutlet weak var stingray1: UIImageView!
    @IBOutlet weak var whale1: UIImageView!
    @IBOutlet weak var shark1: UIImageView!
    @IBOutlet weak var diarySeaweed: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moodImage: UIImageView!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var depthImage: UIImageView!
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var diaryLabel: UILabel!
    @IBOutlet weak var blurView: UIView!
    
    var seaObjets: [UIImageView: String]?
    var diaryWriteViewController: DiaryWriteViewController?
    var currentDepth: AppDepth?
    var menuView: MenuView?
    var alertModalView: AlertModalView?
    var menuToggleFlag: Bool = false
    var uploadModalViewController: UploadModalViewController?
    var diaryInfo: AppDiary?
    var gradientView: UIView?
    let weekdayArray: [String] = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"]
    
    var diaryId: Int = 1
    
    lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: Constants.Design.Image.btnBackWhite, style: .plain, target: self, action: #selector(buttonPressed(sender:)))
        button.tag = NavigationButton.leftButton.rawValue
        button.tintColor = UIColor.white
        return button
    }()
    
    lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "icSubtab"), style: .done, target: self, action: #selector(buttonPressed(sender:)))
        button.tag = NavigationButton.rightButton.rawValue
        button.tintColor = UIColor.white
        return button
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.seaObjets = [
            self.fish1: "fish1",
            self.fish2: "fish2",
            self.dolphin1: "dolphin1",
            self.dolphin2: "dolphin2",
            self.turtle1: "turtle1",
            self.turtle2: "turtle2",
            self.stingray1: "stingray1",
            self.whale1: "whale1",
            self.shark1: "shark1"
        ]
        self.getDiaryWithAPI(completion: updateValues(diaryInfo:))
        
        self.addBlurEffectOnBlurView(view: self.blurView)
        
        self.navigationItem.leftBarButtonItem = self.leftButton
        self.navigationItem.rightBarButtonItem = self.rightButton
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setObjetsByDepth(depth: self.currentDepth ?? AppDepth.depth2m)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setBackgroundColorByDepth(depth: self.currentDepth)
    }
    
    // MARK: - Functions
    
    func getWeekDayFromYearMonthDay(date: String) -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy. MM. dd"
        dateFormatter.locale = Locale.current
        guard let todayDate = dateFormatter.date(from: date) else { return ""}
        let myCalendar = Calendar(identifier: .gregorian)
        let weekday = myCalendar.component(.weekday, from: todayDate)
        return weekdayArray[weekday - 1]
    }
    
    func getFilteredDate(date: String, by: String) -> String {
        return date.components(separatedBy: by).first!
    }
    
    func getYearFromFilteredDate(date: String, by: String) -> Int {
        let yearMonthDay: [String] = self.getFilteredDate(date: date, by: "T").components(separatedBy: by)
        return Int(yearMonthDay[0])!
    }
    
    func getMonthFromFilteredDate(date: String, by: String) -> Int {
        let yearMonthDay: [String] = self.getFilteredDate(date: date, by: "T").components(separatedBy: by)
        return Int(yearMonthDay[1])!
    }
    
    func getDayFromFilteredDate(date: String, by: String) -> Int {
        let yearMonthDay: [String] = self.getFilteredDate(date: date, by: "T").components(separatedBy: by)
        return Int(yearMonthDay[2])!
    }
    
    func getFormattedDate(date: String, by: String) -> String {
        let year = self.getYearFromFilteredDate(date: date, by: by)
        let month = self.getMonthFromFilteredDate(date: date, by: by)
        let day = self.getDayFromFilteredDate(date: date, by: by)
        let weekday = self.getWeekDayFromYearMonthDay(date: "\(year). \(month). \(day)")
        return "\(year). \(String(format: "%02d", month)). \(String(format: "%02d", day)). \(weekday)"
    }
    
    func getFormattedDateForServer(date: String, by: String) -> String {
        let year = self.getYearFromFilteredDate(date: date, by: by)
        let month = self.getMonthFromFilteredDate(date: date, by: by)
        let day = self.getDayFromFilteredDate(date: date, by: by)
        let weekday = self.getWeekDayFromYearMonthDay(date: "\(year). \(month). \(day)")
        return "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day))"
    }
    
    func updateValues(diaryInfo: AppDiary?) {
        self.currentDepth = diaryInfo?.depth
        self.dateLabel.text = diaryInfo?.date
        self.moodImage.image = diaryInfo?.mood.toWhiteIcon()
        self.moodLabel.text = diaryInfo?.mood.toString()
        self.depthLabel.text = diaryInfo?.depth.toString()
        self.sentenceLabel.text = diaryInfo?.sentence.sentence
        self.authorLabel.text = diaryInfo?.sentence.author
        self.bookTitleLabel.text = "<\(diaryInfo!.sentence.bookTitle)>"
        self.authorLabel.text = diaryInfo?.sentence.author
        self.publisherLabel.text = "(\(diaryInfo!.sentence.publisher))"
        self.diaryLabel.text = diaryInfo?.diary
    }
    
    func attachMenuView() {
        self.menuView = MenuView.instantiate()
        if let menuView = self.menuView {
            self.addBlurEffectOnMenuView(view: menuView.menuContainerView)
            menuView.menuDelegate = self
            self.view.insertSubview(menuView, aboveSubview: self.view)
        }
    }
    
    func attachAlertModalView() {
        self.alertModalView = AlertModalView.instantiate(
            alertLabelText: "소중한 일기가 삭제됩니다.\n정말 삭제하시겠어요?",
            leftButtonTitle: NSMutableAttributedString(string: "취소"),
            rightButtonTitle: NSMutableAttributedString(string: "삭제")
        )
        if let alertModalView = self.alertModalView {
            alertModalView.alertModalDelegate = self
            self.view.insertSubview(alertModalView, aboveSubview: self.view)
            alertModalView.setConstraints(view: alertModalView, superView: self.view)
        }
    }
    
    func addBlurEffectOnBlurView(view: UIView) {
        self.addBlurEffectOnView(view: view, cornerRadius: 17, blurStyle: UIBlurEffect.Style.light)
    }
    
    func addBlurEffectOnMenuView(view: UIView) {
        self.addBlurEffectOnView(view: view, cornerRadius: 16, blurStyle: UIBlurEffect.Style.systemThinMaterialLight)
    }
    
    func addBlurEffectOnView(view: UIView, cornerRadius: CGFloat?, blurStyle: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.cornerRadius = cornerRadius ?? 0
        blurEffectView.clipsToBounds = true
        view.insertSubview(blurEffectView, at: 0)
    }
    
    func setBackgroundColorByDepth(depth: AppDepth?) {
        let defaultGradientView = UIView(frame: self.view.frame)
        if self.view.subviews.contains(gradientView ?? defaultGradientView) {
            self.gradientView?.removeFromSuperview()
        }
        
        gradientView = UIView(frame: self.view.frame)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = depth?.toGradientColor()
        gradientView?.layer.addSublayer(gradientLayer)
        
        self.view.insertSubview(gradientView ?? defaultGradientView, at: 0)
    }
    
    func setObjects(keyword: String) {
        let showImages = self.seaObjets?.filter { (image) -> Bool in
            return image.value.contains(keyword)
        }
        let hideImages = self.seaObjets?.filter { (image) -> Bool in
            return !image.value.contains(keyword)
        }
        
        for image in showImages! {
            image.key.isHidden = false
        }
        
        for image in hideImages! {
            image.key.isHidden = true
        }
    }
    
    func setObjetsByDepth(depth: AppDepth) {
        switch depth {
        case .depth2m:
            self.setObjects(keyword: "fish")
        case .depth30m:
            setObjects(keyword: "dolphin")
        case .depth100m:
            setObjects(keyword: "turtle")
        case .depth300m:
            setObjects(keyword: "stingray")
        case .depth700m:
            setObjects(keyword: "whale")
        case .depth1005m:
            setObjects(keyword: "shark")
        case .depthSimhae:
            setObjects(keyword: "nothing")
        }
    }
    
    @objc private func buttonPressed(sender: Any) {
        if let button = sender as? UIBarButtonItem {
            switch button.tag {
            case NavigationButton.leftButton.rawValue:
                self.popToHomeViewController()
            case NavigationButton.rightButton.rawValue:
                if self.menuToggleFlag {
                    self.menuView?.removeFromSuperview()
                } else {
                    self.attachMenuView()
                }
                self.menuToggleFlag.toggle()
            default:
                print("error")
            }
        }
    }
    
    func pushToDeepViewController() {
        let onboardingStoryboard = UIStoryboard(name: Constants.Name.onboardingStoryboard, bundle: nil)
        guard let deepViewController = onboardingStoryboard.instantiateViewController(identifier: Constants.Identifier.deepViewController) as? DeepViewController else { return }
        
        deepViewController.deepViewControllerDelegate = self
        deepViewController.initialDepth = self.currentDepth
        deepViewController.buttonText = "수정하기"
        
        self.navigationController?.pushViewController(deepViewController, animated: true)
    }
    
    func pushToDiaryWriteController() {
        let diaryWriteStoryboard = UIStoryboard(name: Constants.Name.diaryWriteStoryboard, bundle: nil)
        guard let diaryWriteViewController = diaryWriteStoryboard.instantiateViewController(identifier: Constants.Identifier.diaryWriteViewController) as? DiaryWriteViewController else { return }
        
        self.diaryWriteViewController = diaryWriteViewController
        self.diaryWriteViewController?.diaryWriteViewControllerDelegate = self
        
        diaryWriteViewController.diaryInfo = self.diaryInfo
        diaryWriteViewController.isFromDiary = true
        
        self.navigationController?.pushViewController(diaryWriteViewController, animated: true)
    }
    
    func popToHomeViewController() {
        guard let homeViewController = self.navigationController?.viewControllers.filter({$0 is HomeViewController}).first! as? HomeViewController else {
            return
        }
        
        homeViewController.isFromDiary = true
        
        // 홈뷰로 Depth를 넘기는 작업 필요
        self.navigationController?.popToViewController(homeViewController, animated: true)
    }
}

// MARK: - MenuDelegate

extension DiaryViewController: MenuDelegate {
    
    func dateMenuButtonTouchUp(sender: UIButton) {
        self.uploadModalViewController = UploadModalViewController()
        
        if let uploadModalViewController = self.uploadModalViewController {
            
            uploadModalViewController.modalPresentationStyle = .custom
            
            uploadModalViewController.transitioningDelegate = self
            uploadModalViewController.uploadModalDataDelegate = self
            
            uploadModalViewController.year = self.diaryInfo?.year ?? 0
            uploadModalViewController.month = self.diaryInfo?.month ?? 0
            uploadModalViewController.day = self.diaryInfo?.day ?? 0
            
            self.present(uploadModalViewController, animated: true, completion: nil)
        }
        
    }
    
    func depthMenuButtonTouchUp(sender: UIButton) {
        self.pushToDeepViewController()
    }
    
    func diaryMenuButtonTouchUp(sender: UIButton) {
        self.pushToDiaryWriteController()
    }
    
    func deleteMenubuttonTouchUp(sender: UIButton) {
        self.attachAlertModalView()
    }
}

// MARK: - AlertModalDelegate

extension DiaryViewController: AlertModalDelegate {
    func leftButtonTouchUp(button: UIButton) {
        self.alertModalView?.removeFromSuperview()
        self.menuView?.removeFromSuperview()
        self.menuToggleFlag = false
    }
    
    func rightButtonTouchUp(button: UIButton) {
        self.deleteDiaryWithAPI(completion: {
            self.popToHomeViewController()
        })
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension DiaryViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        UploadModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - UploadModalViewControllerDelegate

extension DiaryViewController: UploadModalViewDelegate {
    func passData(_ date: String) {
        let dateArray = date.components(separatedBy: ". ")
        self.diaryInfo?.date = date
        self.diaryInfo?.year = Int(dateArray[0])!
        self.diaryInfo?.month = Int(dateArray[1])!
        self.diaryInfo?.day = Int(dateArray[2])!
        self.diaryInfo?.date = date
        
        self.menuView?.removeFromSuperview()
        self.menuToggleFlag = false
        self.updateValues(diaryInfo: self.diaryInfo)
        self.putDiaryWithAPI(newDiary: self.diaryInfo!, completion: {
            self.getDiaryWithAPI(completion: self.updateValues(diaryInfo:))
        })
    }
}

// MARK: - DiaryWriteViewControllerDelegate

extension DiaryViewController: DiaryWriteViewControllerDelegate {
    func popDiaryWirteViewController(diaryInfo: AppDiary) {
        self.menuView?.removeFromSuperview()
        self.menuToggleFlag = false
        self.updateValues(diaryInfo: diaryInfo)
        self.putDiaryWithAPI(newDiary: diaryInfo, completion: {
            self.getDiaryWithAPI(completion: self.updateValues(diaryInfo:))
        })
    }

}

// MARK: - DeepViewControllerDelegate

extension DiaryViewController: DeepViewControllerDelegate {
    func passData(selectedDepth: AppDepth) {
        self.currentDepth = selectedDepth
        self.diaryInfo?.depth = selectedDepth
        self.setObjetsByDepth(depth: selectedDepth)
        self.setBackgroundColorByDepth(depth: selectedDepth)
        
        self.menuView?.removeFromSuperview()
        self.menuToggleFlag = false
        self.updateValues(diaryInfo: self.diaryInfo)
        self.putDiaryWithAPI(newDiary: self.diaryInfo!, completion: {
            self.getDiaryWithAPI(completion: self.updateValues(diaryInfo:))
        })
    }
}

// MARK: - APIService

extension DiaryViewController {
    func getDiaryWithAPI(completion: @escaping (AppDiary?) -> Void) {
        DiariesWithIDService.shared.getDiaryWithDiaryId(diaryId: self.diaryId) { (result) in
            switch(result) {
            case .success(let data):
                if let diaryData = data as? Diary {
                    let diaryFromServer: AppDiary = AppDiary(
                        date: self.getFormattedDate(date: diaryData.wroteAt, by: "-"),
                        year: self.getYearFromFilteredDate(date: diaryData.wroteAt, by: "-"),
                        month: self.getMonthFromFilteredDate(date: diaryData.wroteAt, by: "-"),
                        day: self.getDayFromFilteredDate(date: diaryData.wroteAt, by: "-"),
                        mood: AppEmotion(rawValue: diaryData.emotionID)!,
                        depth: AppDepth(rawValue: diaryData.depth)!,
                        sentence: AppSentence(
                            id: diaryData.sentenceID,
                            author: diaryData.sentence.writer,
                            bookTitle: diaryData.sentence.bookName,
                            publisher: diaryData.sentence.publisher,
                            sentence: diaryData.sentence.contents
                        ),
                        diary: diaryData.contents
                    )
                    self.diaryInfo = diaryFromServer
                    DispatchQueue.main.async {
                        completion(self.diaryInfo)
                        self.setObjetsByDepth(depth: self.diaryInfo?.depth ?? AppDepth.depth2m)
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
    
    func putDiaryWithAPI(newDiary: AppDiary, completion: @escaping () -> Void) {
        DiariesWithIDService.shared.putDiaryWithDiaryId(
            diaryId: self.diaryId,
            depth: newDiary.depth.rawValue,
            contents: newDiary.diary,
            userId: APIConstants.userId,
            sentenceId: newDiary.sentence.id ?? 1,
            emotionId: newDiary.mood.rawValue,
            wroteAt: self.getFormattedDateForServer(date: newDiary.date, by: ". ")
        ) { (result) in
            switch(result) {
            case .success(let data):
                completion()
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
    
    func deleteDiaryWithAPI(completion: @escaping () -> Void) {
        
        DiariesWithIDService.shared.deleteDiaryWithDiaryId(diaryId: self.diaryId) { (result) in
            switch(result) {
            case .success(let data):
                print("다이어리 삭제성공")
                completion()
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
