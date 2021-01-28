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
    
    var diaryId: Int?
    private var menuToggleFlag: Bool = false
    private var seaObjets: [UIImageView: String]?
    private var diaryInfo: AppDiary?
    private var menuView: MenuView?
    private var gradientView: UIView?
    private var alertModalView: AlertModalView?
    private var diaryWriteViewController: DiaryWriteViewController?
    private var uploadModalViewController: UploadModalViewController?
    
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
        
        self.initializeDiaryViewController()
        self.getDiaryWithAPI(completion: updateDiaryViewController(diaryInfo:))
        self.addBlurEffectOnBlurView(view: self.blurView)
        self.initializeNavigationBar()
    }
    
    // MARK: - Functions
    
    func initializeDiaryViewController() {
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
    }
    
    func initializeNavigationBar() {
        self.navigationItem.leftBarButtonItem = self.leftButton
        self.navigationItem.rightBarButtonItem = self.rightButton
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func updateDiaryViewController(diaryInfo: AppDiary?) {
        guard let safeDiaryInfo = diaryInfo else { return }
        self.updateProperties(diaryInfo: safeDiaryInfo)
        self.updateObjetsByDepth(depth: safeDiaryInfo.depth)
        self.updateBackgroundColorByDepth(depth: safeDiaryInfo.depth)
    }
    
    func updateProperties(diaryInfo: AppDiary?) {
        self.dateLabel.text = diaryInfo?.date.getFormattedDateAndWeekday(with: ". ")
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
            self.view.addSubview(menuView)
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
    
    func updateBackgroundColorByDepth(depth: AppDepth?) {
        
        if let gradientView = self.gradientView {
            if self.view.subviews.contains(gradientView) {
                self.gradientView?.removeFromSuperview()
            }
        }
            
        let gradientLayer: CAGradientLayer
        self.gradientView = UIView(frame: self.view.frame)
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = depth?.toGradientColor()
        self.gradientView?.layer.addSublayer(gradientLayer)
        
        guard let gradientView = self.gradientView else { return }
        self.view.insertSubview(gradientView, at: 0)
    }
    
    func updateObjects(keyword: String) {
        let showImages = self.seaObjets?.filter { (image) -> Bool in
            return image.value.contains(keyword)
        }
        let hideImages = self.seaObjets?.filter { (image) -> Bool in
            return !image.value.contains(keyword)
        }
        
        guard let safeShowImages = showImages, let safeHideImages = hideImages else { return }
        
        for image in safeShowImages {
            image.key.isHidden = false
        }
        
        for image in safeHideImages {
            image.key.isHidden = true
        }
    }
    
    func updateObjetsByDepth(depth: AppDepth) {
        switch depth {
        case .depth2m:
            self.updateObjects(keyword: "fish")
        case .depth30m:
            self.updateObjects(keyword: "dolphin")
        case .depth100m:
            self.updateObjects(keyword: "turtle")
        case .depth300m:
            self.updateObjects(keyword: "stingray")
        case .depth700m:
            self.updateObjects(keyword: "whale")
        case .depth1005m:
            self.updateObjects(keyword: "shark")
        case .depthSimhae:
            self.updateObjects(keyword: "nothing")
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
        deepViewController.initialDepth = self.diaryInfo?.depth
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
        
        // TODO: HomeViewController에서 Depth를 받으면 Depth에 맞는 깊이를 Home에서 보여줌
        self.navigationController?.popToViewController(homeViewController, animated: true)
    }
    
    func presentUpdloadModalViewController() {
        self.uploadModalViewController = UploadModalViewController()
        
        if let uploadModalViewController = self.uploadModalViewController {
            guard let safeDiaryInfo = self.diaryInfo else { return }
            
            uploadModalViewController.modalPresentationStyle = .custom
            uploadModalViewController.transitioningDelegate = self
            uploadModalViewController.uploadModalDataDelegate = self
            uploadModalViewController.year = safeDiaryInfo.date.getYear()
            uploadModalViewController.month = safeDiaryInfo.date.getMonth()
            uploadModalViewController.day = safeDiaryInfo.date.getDay()
            self.present(uploadModalViewController, animated: true, completion: nil)
        }
    }

}

// MARK: - MenuDelegate

extension DiaryViewController: MenuDelegate {
    
    func dateMenuButtonTouchUp(sender: UIButton) {
        self.presentUpdloadModalViewController()
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
        self.diaryInfo?.date = AppDate(formattedDate: date, with: ". ")
        self.menuView?.removeFromSuperview()
        
        guard let safeDiaryInfo = self.diaryInfo else { return }
        self.putDiaryWithAPI(newDiary: safeDiaryInfo, completion: {
            self.getDiaryWithAPI(completion: self.updateDiaryViewController(diaryInfo:))
        })
    }
}

// MARK: - DiaryWriteViewControllerDelegate

extension DiaryViewController: DiaryWriteViewControllerDelegate {
    func popDiaryWirteViewController(diaryInfo: AppDiary?) {
        self.menuView?.removeFromSuperview()
        
        guard let safeDiaryInfo = self.diaryInfo else { return }
        self.putDiaryWithAPI(newDiary: safeDiaryInfo, completion: {
            self.getDiaryWithAPI(completion: self.updateDiaryViewController(diaryInfo:))
        })
    }

}

// MARK: - DeepViewControllerDelegate

extension DiaryViewController: DeepViewControllerDelegate {
    func passData(selectedDepth: AppDepth) {
        self.diaryInfo?.depth = selectedDepth
        self.menuView?.removeFromSuperview()
        
        guard let safeDiaryInfo = self.diaryInfo else { return }
        self.putDiaryWithAPI(newDiary: safeDiaryInfo, completion: {
            self.getDiaryWithAPI(completion: self.updateDiaryViewController(diaryInfo:))
        })
    }
}

// MARK: - APIService

extension DiaryViewController {
    func getDiaryWithAPI(completion: @escaping (AppDiary?) -> Void) {
        guard let diaryId = self.diaryId else { return }
        
        DiariesWithIDService.shared.getDiaryWithDiaryId(diaryId: diaryId) { (result) in
            switch result {
            case .success(let data):
                if let diaryData = data as? Diary {
                    self.diaryInfo = AppDiary(
                        date: AppDate(serverDate: diaryData.wroteAt),
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
                    
                    DispatchQueue.main.async {
                        completion(self.diaryInfo)
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
        guard let diaryId = self.diaryId else { return }
        guard let sentenceId = newDiary.sentence.id else { return }
        DiariesWithIDService.shared.putDiaryWithDiaryId(
            diaryId: diaryId,
            depth: newDiary.depth.rawValue,
            contents: newDiary.diary,
            userId: APIConstants.userId,
            sentenceId: sentenceId,
            emotionId: newDiary.mood.rawValue,
            wroteAt: newDiary.date.getFormattedDate(with: "-")
        ) { (result) in
            switch result {
            case .success:
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
        guard let diaryId = self.diaryId else { return }
        DiariesWithIDService.shared.deleteDiaryWithDiaryId(diaryId: diaryId) { (result) in
            switch result {
            case .success:
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
