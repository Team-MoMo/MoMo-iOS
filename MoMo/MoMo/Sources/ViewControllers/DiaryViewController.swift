//
//  DiaryViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/12.
//

import UIKit

enum DiaryViewNavigationButton: Int {
    case leftButton = 0, rightButton
}

class DiaryViewController: UIViewController {
    
    // MARK: - IBOutlet Properties
    
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
    @IBOutlet weak var descriptionStackView: UIStackView!
    
    // MARK: - Properties
    
    var diaryId: Int?
    var isFromListView: Bool = false
    private var menuToggleFlag: Bool = false
    private var seaObjets: [UIImageView: String]?
    private var diaryInfo: AppDiary?
    private var menuView: MenuView?
    private var gradientView: UIView?
    private var toastView: ToastView?
    private var alertModalView: AlertModalView?
    private var diaryWriteViewController: DiaryWriteViewController?
    private var uploadModalViewController: UploadModalViewController?
    private let initialDepth: AppDepth = AppDepth.depthSimhae
    
    lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: Constants.Design.Image.btnBackWhite, style: .plain, target: self, action: #selector(buttonPressed(sender:)))
        button.tag = DiaryViewNavigationButton.leftButton.rawValue
        button.tintColor = UIColor.white
        return button
    }()
    
    lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "icSubtab"), style: .done, target: self, action: #selector(buttonPressed(sender:)))
        button.tag = DiaryViewNavigationButton.rightButton.rawValue
        button.tintColor = UIColor.white
        return button
    }()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeDiaryViewController()
        self.getDiaryWithAPI(completion: updateDiaryViewController(diaryInfo:))
        self.addBlurEffectOnBlurView(view: self.blurView)
        self.initializeNavigationBar()
    }
    
    // MARK: - Functions
    
    private func initializeDiaryViewController() {
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
        self.updateObjetsByDepth(depth: self.initialDepth)
        self.updateDescriptionStackViewContraints()
        self.hideDiaryViews()
    }
    
    private func initializeNavigationBar() {
        self.navigationItem.leftBarButtonItem = self.leftButton
        self.navigationItem.rightBarButtonItem = self.rightButton
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    private func updateDiaryViewController(diaryInfo: AppDiary?) {
        guard let safeDiaryInfo = diaryInfo, let safeDepth = safeDiaryInfo.depth else { return }
        self.updateProperties(diaryInfo: safeDiaryInfo)
        self.updateObjetsByDepth(depth: safeDepth)
        self.updateBackgroundColorByDepth(depth: safeDiaryInfo.depth)
        self.showDiaryViews()
    }
    
    private func updateDescriptionStackViewContraints() {
        self.descriptionStackView.setCustomSpacing(2, after: self.moodImage)
        self.descriptionStackView.setCustomSpacing(10, after: self.moodLabel)
        self.descriptionStackView.setCustomSpacing(4, after: self.depthImage)
    }
    
    private func updateProperties(diaryInfo: AppDiary?) {
        guard let safeDate = diaryInfo?.date,
              let safeMood = diaryInfo?.mood,
              let safeDepth = diaryInfo?.depth,
              let safeSentence = diaryInfo?.sentence else { return }
        self.dateLabel.attributedText = safeDate.getFormattedDateAndWeekday(with: ". ").textSpacing()
        self.moodImage.image = safeMood.toWhiteIcon()
        self.moodLabel.attributedText = safeMood.toString().textSpacing()
        self.depthLabel.attributedText = safeDepth.toString().textSpacing()
        self.sentenceLabel.attributedText = safeSentence.sentence.textSpacing()
        self.authorLabel.attributedText = safeSentence.author.textSpacing()
        self.bookTitleLabel.attributedText = "<\(safeSentence.bookTitle)>".textSpacing()
        self.authorLabel.attributedText = safeSentence.author.textSpacing()
        self.publisherLabel.attributedText = "(\(safeSentence.publisher))".textSpacing()
        self.diaryLabel.attributedText = diaryInfo?.diary?.textSpacing()
    }
    
    private func attachMenuView() {
        self.menuToggleFlag = true
        self.menuView = MenuView.instantiate()
        if let menuView = self.menuView {
            self.addBlurEffectOnMenuView(view: menuView.menuContainerView)
            menuView.menuDelegate = self
            self.view.addSubview(menuView)
            self.updateMenuViewConstraints(view: menuView)
        }
    }
    
    private func updateMenuViewConstraints(view: UIView) {
        view.snp.makeConstraints({ (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).inset(14)
        })
    }
    
    private func attachAlertModalView() {
        self.alertModalView = AlertModalView.instantiate(alertLabelText: "소중한 일기가 삭제됩니다.\n정말 삭제하시겠어요?", leftButtonTitle: "취소", rightButtonTitle: "삭제")
        if let alertModalView = self.alertModalView {
            alertModalView.alertModalDelegate = self
            self.view.insertSubview(alertModalView, aboveSubview: self.view)
            self.updateAlertModalViewConstraints(view: alertModalView)
        }
    }
    
    private func attachToastViewWithAnimation(message: String) {
        self.attachToastView(message: message)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            animations: {
                self.toastView?.alpha = 1.0
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0.5,
                    animations: {
                        self.toastView?.alpha = 0.0
                    },
                    completion: { _ in
                        self.detachToastView()
                    }
                )
            }
        )
    }
    
    private func attachToastView(message: String) {
        self.toastView = ToastView.instantiate(message: message)
        guard let toastView = self.toastView else { return }
        toastView.alpha = 0.0
        self.view.insertSubview(toastView, aboveSubview: self.view)
        self.updateToastViewConstraints(view: toastView)
    }
    
    private func detachToastView() {
        self.toastView?.removeFromSuperview()
    }
    
    private func detachMenuView() {
        self.menuToggleFlag = false
        self.menuView?.removeFromSuperview()
    }
    
    private func detachAlertModalView() {
        self.alertModalView?.removeFromSuperview()
    }
    
    private func updateAlertModalViewConstraints(view: UIView) {
        view.snp.makeConstraints({ (make) in
            make.width.height.centerX.centerY.equalTo(self.view)
        })
    }
    
    private func updateToastViewConstraints(view: UIView) {
        view.snp.makeConstraints({ (make) in
            make.width.height.centerX.centerY.equalTo(self.view)
        })
    }
    
    private func addBlurEffectOnBlurView(view: UIView) {
        self.addBlurEffectOnView(view: view, cornerRadius: 17, blurStyle: UIBlurEffect.Style.light, alpha: 0.3)
    }
    
    private func addBlurEffectOnMenuView(view: UIView) {
        self.addBlurEffectOnView(view: view, cornerRadius: 16, blurStyle: UIBlurEffect.Style.systemThinMaterialLight, alpha: 1.0)
    }
    
    private func addBlurEffectOnView(view: UIView, cornerRadius: CGFloat?, blurStyle: UIBlurEffect.Style, alpha: CGFloat) {
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = alpha
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.cornerRadius = cornerRadius ?? 0
        blurEffectView.clipsToBounds = true
        view.insertSubview(blurEffectView, at: 0)
    }
    
    private func updateBackgroundColorByDepth(depth: AppDepth?) {
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
    
    private func updateObjects(keyword: String) {
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
    
    private func updateObjetsByDepth(depth: AppDepth) {
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
    
    private func hideDiaryViews() {
        self.dateLabel.isHidden = true
        self.descriptionStackView.isHidden = true
        self.sentenceLabel.isHidden = true
        self.bookTitleLabel.isHidden = true
        self.authorLabel.isHidden = true
        self.publisherLabel.isHidden = true
        self.diaryLabel.isHidden = true
    }
    
    private func showDiaryViews() {
        self.dateLabel.isHidden = false
        self.descriptionStackView.isHidden = false
        self.sentenceLabel.isHidden = false
        self.bookTitleLabel.isHidden = false
        self.authorLabel.isHidden = false
        self.publisherLabel.isHidden = false
        self.diaryLabel.isHidden = false
    }
    
    @objc private func buttonPressed(sender: Any) {
        if let button = sender as? UIBarButtonItem {
            switch button.tag {
            case DiaryViewNavigationButton.leftButton.rawValue:
                if self.isFromListView {
                    self.isFromListView = false
                    self.popToListViewController()
                } else {
                    self.popToHomeViewController()
                }
            case DiaryViewNavigationButton.rightButton.rawValue:
                if self.menuToggleFlag {
                    self.detachMenuView()
                } else {
                    self.attachMenuView()
                }
            default:
                print("error")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard touch?.view == self.menuView?.dateMenuView || touch?.view == self.menuView?.depthMenuView ||
                touch?.view == self.menuView?.diaryWriteMenuView || touch?.view == self.menuView?.deleteMenuView ||
                touch?.view is UIVisualEffectView else {
            self.detachMenuView()
            return
        }
    }
    
    private func isChanged<T: Equatable>(oldValue: T, newValue: T) -> Bool {
        return oldValue != newValue
    }
    
    private func pushToDeepViewController() {
        let onboardingStoryboard = UIStoryboard(name: Constants.Name.onboardingStoryboard, bundle: nil)
        guard let deepViewController = onboardingStoryboard.instantiateViewController(identifier: Constants.Identifier.deepViewController) as? DeepViewController else { return }
        deepViewController.deepViewControllerDelegate = self
        deepViewController.initialDepth = self.diaryInfo?.depth
        deepViewController.diaryInfo = self.diaryInfo
        deepViewController.deepViewUsage = .diary
        self.navigationController?.pushViewController(deepViewController, animated: true)
    }
    
    private func pushToDiaryWriteController() {
        let diaryWriteStoryboard = UIStoryboard(name: Constants.Name.diaryWriteStoryboard, bundle: nil)
        guard let diaryWriteViewController = diaryWriteStoryboard.instantiateViewController(identifier: Constants.Identifier.diaryWriteViewController) as? DiaryWriteViewController else { return }
        
        self.diaryWriteViewController = diaryWriteViewController
        self.diaryWriteViewController?.diaryWriteViewControllerDelegate = self
        
        diaryWriteViewController.diaryInfo = self.diaryInfo
        diaryWriteViewController.isFromDiary = true
        
        self.navigationController?.pushViewController(diaryWriteViewController, animated: true)
    }
    
    private func popToHomeViewController() {
        guard let homeViewController = self.navigationController?.viewControllers.filter({$0 is HomeViewController}).first! as? HomeViewController else {
            return
        }
        homeViewController.isFromDiary = true
        self.navigationController?.popToViewController(homeViewController, animated: true)
    }
    
    private func popToListViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func presentUpdloadModalViewController() {
        self.uploadModalViewController = UploadModalViewController()
        
        if let uploadModalViewController = self.uploadModalViewController {
            guard let safeDate = self.diaryInfo?.date else { return }
            
            uploadModalViewController.modalPresentationStyle = .custom
            uploadModalViewController.transitioningDelegate = self
            uploadModalViewController.uploadModalDataDelegate = self
            uploadModalViewController.year = safeDate.getYear()
            uploadModalViewController.month = safeDate.getMonth()
            uploadModalViewController.day = safeDate.getDay()
            self.present(uploadModalViewController, animated: true, completion: nil)
        }
    }

}

// MARK: - MenuDelegate

extension DiaryViewController: MenuViewDelegate {
    
    func dateMenuButtonTouchUp(sender: UITapGestureRecognizer) {
        self.presentUpdloadModalViewController()
    }
    
    func depthMenuButtonTouchUp(sender: UITapGestureRecognizer) {
        self.pushToDeepViewController()
    }
    
    func diaryMenuButtonTouchUp(sender: UITapGestureRecognizer) {
        self.pushToDiaryWriteController()
    }
    
    func deleteMenubuttonTouchUp(sender: UITapGestureRecognizer) {
        self.attachAlertModalView()
    }
}

// MARK: - AlertModalDelegate

extension DiaryViewController: AlertModalDelegate {
    func leftButtonTouchUp(button: UIButton) {
        self.detachAlertModalView()
        self.detachMenuView()
    }
    
    func rightButtonTouchUp(button: UIButton) {
        self.deleteDiaryWithAPI(completion: {
            if self.isFromListView {
                self.isFromListView = false
                self.popToListViewController()
            } else {
                self.popToHomeViewController()
            }
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
        self.detachMenuView()
        
        guard let oldDate = self.diaryInfo?.date else { return }
        let newDate: AppDate = AppDate(formattedDate: date, with: ". ")
        
        if self.isChanged(oldValue: oldDate, newValue: newDate) {
            
            self.diaryInfo?.date = newDate
            guard let safeDiaryInfo = self.diaryInfo else { return }
            
            self.putDiaryWithAPI(newDiary: safeDiaryInfo, completion: {
                self.getDiaryWithAPI(completion: self.updateDiaryViewController(diaryInfo:))
                self.attachToastViewWithAnimation(message: "날짜가 수정되었습니다")
            })
        }
    }
}

// MARK: - DiaryWriteViewControllerDelegate

extension DiaryViewController: DiaryWriteViewControllerDelegate {
    func popToDiaryViewController(newDiaryInfo: AppDiary?) {
        self.detachMenuView()
        
        guard let oldDiary = self.diaryInfo?.diary else { return }
        guard let newDiary = newDiaryInfo?.diary else { return }
        
        if self.isChanged(oldValue: oldDiary, newValue: newDiary) {
            
            guard let safeDiaryInfo = newDiaryInfo else { return }
            
            self.putDiaryWithAPI(newDiary: safeDiaryInfo, completion: {
                self.getDiaryWithAPI(completion: self.updateDiaryViewController(diaryInfo:))
                self.attachToastViewWithAnimation(message: "일기가 수정되었습니다")
            })
        }
    }
}

// MARK: - DeepViewControllerDelegate

extension DiaryViewController: DeepViewControllerDelegate {
    func passData(selectedDepth: AppDepth) {
        self.detachMenuView()
        
        guard let oldDepth: AppDepth = self.diaryInfo?.depth else { return }
        let newDepth: AppDepth = selectedDepth
        
        if self.isChanged(oldValue: oldDepth, newValue: newDepth) {
            
            self.diaryInfo?.depth = newDepth
            guard let safeDiaryInfo = self.diaryInfo else { return }
            
            self.putDiaryWithAPI(newDiary: safeDiaryInfo, completion: {
                self.getDiaryWithAPI(completion: self.updateDiaryViewController(diaryInfo:))
                
                self.attachToastViewWithAnimation(message: "깊이가 수정되었습니다")
                
            })
        }
    }
}

// MARK: - APIServices

extension DiaryViewController {
    private func getDiaryWithAPI(completion: @escaping (AppDiary?) -> Void) {
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
                print("pathErr in getDiaryWithAPI")
            case .serverErr:
                print("serverErr in getDiaryWithAPI")
            case .networkFail:
                print("networkFail in getDiaryWithAPI")
            }
        }
    }
    
    private func putDiaryWithAPI(newDiary: AppDiary, completion: @escaping () -> Void) {
        guard let diaryId = self.diaryId,
              let sentenceId = newDiary.sentence?.id,
              let depthId = newDiary.depth?.rawValue,
              let diary = newDiary.diary,
              let moodId = newDiary.mood?.rawValue,
              let date = newDiary.date else { return }
        
        DiariesWithIDService.shared.putDiaryWithDiaryId(
            diaryId: diaryId,
            depth: depthId,
            contents: diary,
            userId: APIConstants.userId,
            sentenceId: sentenceId,
            emotionId: moodId,
            wroteAt: date.getFormattedDate(with: "-")
        ) { (result) in
            switch result {
            case .success:
                completion()
            case .requestErr(let errorMessage):
                print(errorMessage)
            case .pathErr:
                print("pathErr in putDiaryWithAPI")
            case .serverErr:
                print("serverErr in putDiaryWithAPI")
            case .networkFail:
                print("networkFail in putDiaryWithAPI")
            }
        }
    }
    
    private func deleteDiaryWithAPI(completion: @escaping () -> Void) {
        guard let diaryId = self.diaryId else { return }
        DiariesWithIDService.shared.deleteDiaryWithDiaryId(diaryId: diaryId) { (result) in
            switch result {
            case .success:
                completion()
            case .requestErr(let errorMessage):
                print(errorMessage)
            case .pathErr:
                print("pathErr in deleteDiaryWithAPI")
            case .serverErr:
                print("serverErr in deleteDiaryWithAPI")
            case .networkFail:
                print("networkFail in deleteDiaryWithAPI")
            }
        }
    }
}
