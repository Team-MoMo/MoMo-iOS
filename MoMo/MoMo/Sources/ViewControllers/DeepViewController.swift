//
//  DeepViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/10.
//

import UIKit
import SnapKit

protocol DeepViewControllerDelegate: class {
    func passData(selectedDepth: AppDepth)
}

enum DeepViewUsage: Int {
    case onboarding = 0, upload, diary
}

class DeepViewController: UIViewController {

    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moodImage: UIImageView!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var gradientScrollView: UIScrollView!
    @IBOutlet weak var gradientBackgroundView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var deepSliderContainerView: UIView!
    @IBOutlet weak var depthSelectionButton: UIButton!
    @IBOutlet weak var infoLabelVerticalSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurViewVerticalSpacingConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var diaryInfo: AppDiary?
    var initialDepth: AppDepth?
    var deepViewUsage: DeepViewUsage = .onboarding
    private var deepSliderValue: Float = 0
    private var deepSliderView: DeepSliderView?
    private var viewWidth: CGFloat?
    private var viewHeight: CGFloat?
    private var viewXpos: CGFloat?
    private var viewYpos: CGFloat?
    private let infoLabelVerticalSpacing: CGFloat = 66
    private let blurViewVerticalSpacing: CGFloat = 75
    private var alertModalView: AlertModalView?
    private var blurEffectView: CustomIntensityVisualEffectView?
    weak var deepViewControllerDelegate: DeepViewControllerDelegate?
    private lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: Constants.Design.Image.btnBackBlack, style: .plain, target: self, action: #selector(touchBackButton))
        button.tintColor = .white
        return button
    }()
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: Constants.Design.Image.btnCloseWhite, style: .plain, target: self, action: #selector(touchCrossButton))
        button.tintColor = .white
        return button
    }()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDeepViewController()
        self.initializeNavigationBar()
        self.addGradientOnGradientBackgroundView()
        DispatchQueue.main.async {
            self.changeBackground(value: self.deepSliderValue)
            self.addCircleIndicatorsOnDeepPointSliderView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.removeBlurEffectOnBlurView()
        self.addBlurEffectOnBlurView()
    }
    
    // MARK: - Functions
    
    private func initializeDeepViewController() {
        
        self.buttonRoundedUp()
        self.updateViewContraints()
        self.resizeGradientBackgroundView()
        self.addBlurEffectOnBlurView()
        self.attachDeepSliderView()
        
        let buttonText: String
        var infoText: String = "감정이 얼마나 깊은가요?\n나만의 바다에 기록해보세요"
        switch self.deepViewUsage {
        case .onboarding:
            self.hideDateLabel()
            self.hideMoodLabelAndImage()
            infoText = "오늘의 감정은\n잔잔한가요, 깊은가요?\n스크롤을 움직여서 기록해보세요"
            self.infoLabelVerticalSpacingConstraint.constant = self.infoLabelVerticalSpacing
            self.blurViewVerticalSpacingConstraint.constant = self.blurViewVerticalSpacing
            buttonText = "시작하기"
        case .upload:
            buttonText = "기록하기"
        case .diary:
            buttonText = "수정하기"
        }
        self.infoLabel.attributedText = infoText.textSpacing()
        
        self.updateDeepViewController()
        self.depthSelectionButton.setAttributedTitle(buttonText.textSpacing(), for: .normal)
    }
    
    private func initializeNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationItem.leftBarButtonItem = self.leftButton
        switch self.deepViewUsage {
        case .onboarding:
            self.navigationItem.leftBarButtonItem = nil
        case .upload:
            self.navigationItem.rightBarButtonItem = self.rightButton
        case .diary:
            return
        }
    }
    
    private func updateDeepViewController() {
        if let date = self.diaryInfo?.date, let mood = self.diaryInfo?.mood {
            self.dateLabel.attributedText = date.getFormattedDateAndWeekday(with: ". ").textSpacing()
            self.moodImage.image = mood.toWhiteIcon()
            self.moodLabel.attributedText = mood.toString().textSpacing()
        }
    }
    
    private func attachDeepSliderView() {
        self.deepSliderView = DeepSliderView.instantiate(initialDepth: self.initialDepth ?? .depth2m)
        self.deepSliderValue = Float(self.initialDepth?.rawValue ?? 0) / 6
        
        if let deepSliderView = self.deepSliderView {
            deepSliderView.sliderDelegate = self
            self.view.addSubview(deepSliderView)
            self.updateDeepSliderViewContraints(view: deepSliderView)
        }
    }
    
    private func attachAlertModalView() {
        self.alertModalView = AlertModalView.instantiate(
            alertLabelText: "작성한 내용이 모두 삭제됩니다.\n정말 닫으시겠어요?",
            leftButtonTitle: "취소",
            rightButtonTitle: "닫기"
        )

        if let alertModalView = self.alertModalView {
            alertModalView.alertModalDelegate = self
            self.view.insertSubview(alertModalView, aboveSubview: self.view)
            self.updateAlertModalViewConstraints(view: alertModalView)
        }
    }
    
    private func attachActivityIndicator() {
        self.view.addSubview(self.activityIndicator)
    }
    
    private func detachActivityIndicator() {
        if self.activityIndicator.isAnimating {
            self.activityIndicator.stopAnimating()
        }
        self.activityIndicator.removeFromSuperview()
    }
    
    private func updateAlertModalViewConstraints(view: UIView) {
        view.snp.makeConstraints({ (make) in
            make.width.height.centerX.centerY.equalTo(self.view)
        })
    }
    
    private func updateDeepSliderViewContraints(view: UIView) {
        view.snp.makeConstraints { (make) in
            make.height.equalTo(self.deepSliderContainerView.snp.width)
            make.width.equalTo(self.deepSliderContainerView.snp.height)
            make.centerX.equalTo(self.deepSliderContainerView.snp.centerX)
            make.centerY.equalTo(self.deepSliderContainerView.snp.centerY)
        }
    }
    
    private func updateViewContraints() {
        self.viewWidth = self.view.frame.size.width
        self.viewHeight = self.view.frame.size.height
        self.viewXpos = self.view.frame.origin.x
        self.viewYpos = self.view.frame.origin.y
    }
    
    private func resizeGradientBackgroundView() {
        self.gradientBackgroundView.frame = CGRect(x: self.viewXpos!, y: self.viewYpos!, width: self.viewWidth!, height: self.viewHeight! * 7)
    }
    
    private func buttonRoundedUp() {
        self.depthSelectionButton.layer.cornerRadius = self.depthSelectionButton.frame.size.height / 2
        self.depthSelectionButton.clipsToBounds = true
    }
    
    private func enableDepthSelectionButton() {
        self.depthSelectionButton.isUserInteractionEnabled = true
    }
    
    private func disableDepthSelectionButton() {
        self.depthSelectionButton.isUserInteractionEnabled = false
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func touchCrossButton() {
        self.attachAlertModalView()
    }
    
    private func hideDateLabel() {
        self.dateLabel.isHidden = true
    }
    
    private func hideMoodLabelAndImage() {
        self.moodImage.isHidden = true
        self.moodLabel.isHidden = true
    }
    
    func removeBlurEffectOnBlurView() {
        self.blurEffectView?.removeFromSuperview()
    }
    
    func addBlurEffectOnBlurView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        self.blurEffectView = CustomIntensityVisualEffectView(effect: blurEffect, intensity: 0.1)
        if let blurEffectView = self.blurEffectView {
            blurEffectView.frame = self.blurView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.blurView.addSubview(blurEffectView)
        }
    }
    
    private func addCircleIndicatorsOnDeepPointSliderView() {
        guard let deepSliderView = self.deepSliderView else { return}
        
        let deepPointSliderHeight = deepSliderView.deepPointSlider.frame.size.height
        let deepPointSliderWidth = deepSliderView.deepPointSlider.frame.size.width - deepPointSliderHeight
        let circleIndicatorDiameter: CGFloat = 10
        
        for index in 0...6 {
            let circle = UIView(
                frame: CGRect(
                    x: deepPointSliderHeight/2 - deepPointSliderHeight/4 + deepPointSliderWidth/6 * CGFloat(index) + circleIndicatorDiameter * 0.65,
                    y: deepPointSliderHeight/2 - circleIndicatorDiameter * 0.65,
                    width: circleIndicatorDiameter,
                    height: circleIndicatorDiameter
                )
            )
            
            circle.layer.cornerRadius = circleIndicatorDiameter/2
            circle.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            deepSliderView.deepPointSlider.insertSubview(circle, at: 0)
        }
    }
    
    private func addGradientOnGradientBackgroundView() {
        for index in 0...6 {
            let gradientView = UIView(frame: CGRect(x: self.viewXpos!, y: self.viewHeight! * CGFloat(index), width: self.viewWidth!, height: self.viewHeight!))
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = gradientView.bounds
            gradientLayer.colors = AppDepth(rawValue: index)?.toGradientColor()
            gradientView.layer.addSublayer(gradientLayer)
            self.gradientBackgroundView.addSubview(gradientView)
        }
    }
    
    private func pushToLoginViewController() {
        let loginStoryboard = UIStoryboard(name: Constants.Name.loginStoryboard, bundle: nil)
        guard let loginViewController = loginStoryboard.instantiateViewController(identifier: Constants.Identifier.loginViewController) as? LoginViewController else { return }
        loginViewController.currentColorSet = Int(round(self.deepSliderValue * 6))
        self.navigationController?.pushViewController(loginViewController, animated: true)
        
    }
    
    private func popToHomeViewController() {
        guard let homeViewController = self.navigationController?.viewControllers.filter({$0 is HomeViewController}).first! as? HomeViewController else {
            return
        }
        self.navigationController?.popToViewController(homeViewController, animated: true)
    }
    
    private func popToDiaryViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func pushToDiaryViewController(diaryId: Int, depth: AppDepth?) {
        let diaryStoryboard = UIStoryboard(name: Constants.Name.diaryStoryboard, bundle: nil)
        guard let diaryViewController = diaryStoryboard.instantiateViewController(identifier: Constants.Identifier.diaryViewController) as? DiaryViewController else { return }
        diaryViewController.diaryId = diaryId
        diaryViewController.initialDepth = depth
        self.navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    @IBAction func touchDepthSelectionButton(_ sender: UIButton) {
        switch self.deepViewUsage {
        case .onboarding:
            self.pushToLoginViewController()
        case .upload:
            self.disableDepthSelectionButton()
            guard let diary = self.diaryInfo?.diary,
                  let sentenceId = self.diaryInfo?.sentence?.id,
                  let emotionId = self.diaryInfo?.mood?.rawValue,
                  let wroteAt = self.diaryInfo?.date?.getFormattedDate(with: "-") else {
                return
            }
            self.postDiariesWithAPI(
                contents: diary,
                depth: Int(round(self.deepSliderValue * 6)),
                userId: Int(APIConstants.userId),
                sentenceId: sentenceId,
                emotionId: emotionId,
                wroteAt: wroteAt
            )
        case .diary:
            self.disableDepthSelectionButton()
            self.deepViewControllerDelegate?.passData(
                selectedDepth: AppDepth(rawValue: Int(round(self.deepSliderValue * 6))) ?? AppDepth.depth2m)
            self.popToDiaryViewController()
        }
    }
}

// MARK: - SliderDelegate

extension DeepViewController: SliderDelegate {
    
    func deepPointSliderValueChanged(slider: UISlider) {
        self.updateSlider(slider, sliderValue: slider.value)
    }
    
    func deepLabelSliderValueChanged(slider: UISlider) {
        self.updateSlider(slider, sliderValue: slider.value)
    }
    
    func updateSlider(_ slider: UISlider, sliderValue: Float) {
        
        self.deepSliderValue = round(sliderValue * 6) / 6
        
        DispatchQueue.main.async {
            self.changeBackgroundWithAnimation(value: self.deepSliderValue)
        }
        self.labelChanged(value: self.deepSliderValue)
        
        let value = slider.isTracking ? sliderValue : self.deepSliderValue
        deepSliderView?.deepPointSlider.setValue(value, animated: false)
        deepSliderView?.deepLineSlider.setValue(value, animated: false)
        deepSliderView?.deepLabelSlider.setValue(value, animated: false)
        
    }
    
    func changeBackgroundWithAnimation(value: Float) {
        UIView.transition(
            with: self.gradientBackgroundView,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
                self.changeBackground(value: value)
            },
            completion: nil
        )
    }
    
    func changeBackground(value: Float) {
        self.gradientBackgroundView.frame.origin.y = -CGFloat(self.deepSliderValue) * 6 * self.viewHeight!
    }
    
    func labelChanged(value: Float) {
        deepSliderView?.deepLabelSlider.setThumbImage(AppDepth(rawValue: Int(value * 6))?.toLabelImage(), for: .normal)
    }
}

// MARK: - API Services
extension DeepViewController {
    private func postDiariesWithAPI(contents: String, depth: Int, userId: Int, sentenceId: Int, emotionId: Int, wroteAt: String) {
        self.attachActivityIndicator()
        DiariesService.shared.postDiaries(contents: contents, depth: depth, userId: userId, sentenceId: sentenceId, emotionId: emotionId, wroteAt: wroteAt) { networkResult in
            self.detachActivityIndicator()
            self.enableDepthSelectionButton()
            
            switch networkResult {
            case .success(let data):
                if let serverData = data as? CreateDiary {
                    self.pushToDiaryViewController(diaryId: serverData.id, depth: AppDepth(rawValue: serverData.depth))
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr in postDiariesWithAPI")
            case .serverErr:
                print("serverErr in postDiariesWithAPI")
            case .networkFail:
                print("networkFail in postDiariesWithAPI")
            }
        }
    }
}

// MARK: - AlertModalDelegate

extension DeepViewController: AlertModalDelegate {
    
    func leftButtonTouchUp(button: UIButton) {
        self.alertModalView?.removeFromSuperview()
    }
    
    func rightButtonTouchUp(button: UIButton) {
        self.alertModalView?.removeFromSuperview()
        self.popToHomeViewController()
    }
}
