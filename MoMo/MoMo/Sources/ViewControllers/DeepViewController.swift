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

enum DepthSelectionButtonUsage: Int {
    case onboarding = 0, upload, diary
}

class DeepViewController: UIViewController {

    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var gradientScrollView: UIScrollView!
    @IBOutlet weak var gradientBackgroundView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var depthSelectionButton: UIButton!
    
    // MARK: - Properties
    
    var diaryInfo: AppDiary?
    var initialDepth: AppDepth?
    var depthSeclectionButtonUsage: DepthSelectionButtonUsage = .onboarding
    private var deepSliderValue: Float = 0
    private var deepSliderView: DeepSliderView?
    private var viewWidth: CGFloat?
    private var viewHeight: CGFloat?
    private var viewXpos: CGFloat?
    private var viewYpos: CGFloat?
    weak var deepViewControllerDelegate: DeepViewControllerDelegate?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDeepViewController()
        self.initializeNavigationBar()
        self.addGradientOnGradientBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCircleIndicatorsOnDeepPointSliderView()
        self.changeBackgroundWithAnimation(value: self.deepSliderValue)
    }
    
    // MARK: - Functions
    
    func initializeDeepViewController() {
        
        self.buttonRoundedUp()
        self.updateViewContraints()
        self.resizeGradientBackgroundView()
        self.addBlurEffectOnBlurView()
        self.attachDeepSliderView()
        
        let buttonText: String
        var infoText: String = "감정이 얼마나 깊은가요?\n나만의 바다에 기록해보세요"
        switch self.depthSeclectionButtonUsage {
        case .onboarding:
            infoText = "오늘의 감정은\n잔잔한가요, 깊은가요?\n스크롤을 움직여서 기록해보세요"
            buttonText = "시작하기"
        case .upload:
            buttonText = "기록하기"
        case .diary:
            buttonText = "수정하기"
        }
        self.infoLabel.text = infoText
        self.depthSelectionButton.setTitle(buttonText, for: .normal)
    }
    
    func initializeNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        let leftButton = UIBarButtonItem(image: Constants.Design.Image.btnBackBlack, style: .plain, target: self, action: #selector(touchBackButton))
        leftButton.tintColor = .white
        self.navigationItem.leftBarButtonItems = [leftButton]
    }
    
    func attachDeepSliderView() {
        self.deepSliderView = DeepSliderView.instantiate(initialDepth: self.initialDepth ?? .depth2m)
        self.deepSliderValue = Float(self.initialDepth?.rawValue ?? 0) / 6
        
        if let deepSliderView = self.deepSliderView {
            
            deepSliderView.sliderDelegate = self
            
            self.view.addSubview(deepSliderView)
            
            deepSliderView.snp.makeConstraints { (make) in
                make.height.equalTo(self.view.frame.size.width * 2)
                make.width.equalTo(self.view.frame.size.height * 0.5)
            }
            
            deepSliderView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.view.snp.leading).inset(47)
                make.centerY.equalTo(self.blurView).offset(-35)
            }
            
        }
    }
    
    func updateViewContraints() {
        self.viewWidth = self.view.frame.size.width
        self.viewHeight = self.view.frame.size.height
        self.viewXpos = self.view.frame.origin.x
        self.viewYpos = self.view.frame.origin.y
    }
    
    func resizeGradientBackgroundView() {
        self.gradientBackgroundView.frame = CGRect(x: self.viewXpos!, y: self.viewYpos!, width: self.viewWidth!, height: self.viewHeight! * 7)
    }
    
    func buttonRoundedUp() {
        self.depthSelectionButton.layer.cornerRadius = self.depthSelectionButton.frame.size.height / 2
        self.depthSelectionButton.clipsToBounds = true
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addBlurEffectOnBlurView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.blurView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurView.addSubview(blurEffectView)
    }
    
    func addCircleIndicatorsOnDeepPointSliderView() {
        let deepPointSliderHeight = deepSliderView!.deepPointSlider.frame.size.height
        let deepPointSliderWidth = deepSliderView!.deepPointSlider.frame.size.width - deepPointSliderHeight
        let circleIndicatorDiameter: CGFloat = 10
        
        for index in 0...6 {
            let circle = UIView(
                frame: CGRect(
                    x: deepPointSliderHeight/2 - deepPointSliderHeight/4 + deepPointSliderWidth/6 * CGFloat(index),
                    y: deepPointSliderHeight/2 - deepPointSliderHeight/4,
                    width: circleIndicatorDiameter,
                    height: circleIndicatorDiameter
                )
            )
            
            circle.layer.cornerRadius = circleIndicatorDiameter/2
            circle.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            deepSliderView?.deepPointSlider.insertSubview(circle, at: 0)
        }
    }
    
    func addGradientOnGradientBackgroundView() {
        for index in 0...6 {
            let gradientView = UIView(frame: CGRect(x: self.viewXpos!, y: self.viewHeight! * CGFloat(index), width: self.viewWidth!, height: self.viewHeight!))
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = gradientView.bounds
            gradientLayer.colors = AppDepth(rawValue: index)?.toGradientColor()
            gradientView.layer.addSublayer(gradientLayer)
            self.gradientBackgroundView.addSubview(gradientView)
        }
    }
    
    func pushToLoginViewController() {
        let loginStoryboard = UIStoryboard(name: Constants.Name.loginStoryboard, bundle: nil)
        guard let loginViewController = loginStoryboard.instantiateViewController(identifier: Constants.Identifier.loginViewController) as? LoginViewController else { return }
        loginViewController.currentColorSet = Int(round(self.deepSliderValue * 6))
        self.navigationController?.pushViewController(loginViewController, animated: true)
        
    }
    
    func postDiariesWithAPI(contents: String, depth: Int, userId: Int, sentenceId: Int, emotionId: Int, wroteAt: String) {
        DiariesService.shared.postDiaries(contents: contents, depth: depth, userId: userId, sentenceId: sentenceId, emotionId: emotionId, wroteAt: wroteAt) { networkResult in
            switch networkResult {
            case .success(let data):
                if let serverData = data as? CreateDiary {
                    self.pushToDiaryViewController(diaryId: serverData.id)
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
    
    func pushToDiaryViewController(diaryId: Int) {
        let diaryStoryboard = UIStoryboard(name: Constants.Name.diaryStoryboard, bundle: nil)
        guard let diaryViewController = diaryStoryboard.instantiateViewController(identifier: Constants.Identifier.diaryViewController) as? DiaryViewController else { return }
        diaryViewController.diaryId = diaryId
        self.navigationController?.pushViewController(diaryViewController, animated: true)
        
    }
    
    @IBAction func startButtonTouchUp(_ sender: UIButton) {
        
        switch self.depthSeclectionButtonUsage {
        case .onboarding:
            self.pushToLoginViewController()
        case .upload:
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
            self.deepViewControllerDelegate?.passData(
                selectedDepth: AppDepth(rawValue: Int(round(self.deepSliderValue * 6))) ?? AppDepth.depth2m)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

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
        deepSliderView?.deepLabelSlider.setThumbImage(deepSliderView?.labelImages[Int(value * 6)], for: .normal)
    }
}
