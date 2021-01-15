//
//  DeepViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/10.
//

import UIKit
import SnapKit

protocol DeepViewControllerDelegate: class {
    func passData(selectedDepth: Depth)
}

enum Depth: Int {
    case depth2m = 0, depth30m, depth100m, depth300m, depth700m, depth1005m, depthSimhae
    
    func toString() -> String {
        switch self {
        case .depth2m:
            return "2m"
        case .depth30m:
            return "30m"
        case .depth100m:
            return "100m"
        case .depth300m:
            return "300m"
        case .depth700m:
            return "700m"
        case .depth1005m:
            return "1005m"
        case .depthSimhae:
            return "심해"
        }
    }
    
    func toGradientColor() -> [CGColor] {
        switch self {
        case .depth2m:
            return [UIColor.Gradient1.cgColor, UIColor.Gradient2.cgColor]
        case .depth30m:
            return [UIColor.Gradient2.cgColor, UIColor.Gradient3.cgColor]
        case .depth100m:
            return [UIColor.Gradient3.cgColor, UIColor.Gradient4.cgColor]
        case .depth300m:
            return [UIColor.Gradient4.cgColor, UIColor.Gradient5.cgColor]
        case .depth700m:
            return [UIColor.Gradient5.cgColor, UIColor.Gradient6.cgColor]
        case .depth1005m:
            return [UIColor.Gradient6.cgColor, UIColor.Gradient7.cgColor]
        case .depthSimhae:
            return [UIColor.Gradient7.cgColor, UIColor.Gradient8.cgColor]
        }
    }
}

class DeepViewController: UIViewController {

    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var gradientScrollView: UIScrollView!
    @IBOutlet weak var gradientBackgroundView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - Properties
    
    var mood: Mood?
    var sentence: Sentence?
    var journal: String = ""
    var date: String = ""
    
    let dafaultInfoLabel: String = "오늘의 감정은\n잔잔한가요, 깊은가요?\n스크롤을 움직여서 기록해보세요"
    var deepSliderView: DeepSliderView?
    var deepSliderValue: Float = 0
    var initialDepth: Depth?
    var viewWidth: CGFloat?
    var viewHeight: CGFloat?
    var viewXpos: CGFloat?
    var viewYpos: CGFloat?
    weak var deepViewControllerDelegate: DeepViewControllerDelegate?
    
    // 버튼 텍스트가 시작하기일때 그리고 기록하기를 기준으로 분기할거예요
    var buttonText: String = "시작하기"
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.infoLabel.text = self.dafaultInfoLabel
        self.buttonRoundedUp()
        self.startButton.titleLabel?.text = self.buttonText
        self.getViewContraints()
        self.resizeGradientBackgroundView()
        self.addBlurEffectOnBlurView()
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
        self.addGradientOnGradientBackgroundView()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        let leftButton = UIBarButtonItem(image: Constants.Design.Image.btnBackBlack, style: .plain, target: self, action: #selector(touchBackButton))
        leftButton.tintColor = .white
        self.navigationItem.leftBarButtonItems = [leftButton]
    }
    
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startButton.setTitle(buttonText, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCircleIndicatorsOnDeepPointSliderview()
        self.changeBackgroundWithAnimation(value: self.deepSliderValue)
    }
    
    // MARK: - Functions
    
    func getViewContraints() {
        self.viewWidth = self.view.frame.size.width
        self.viewHeight = self.view.frame.size.height
        self.viewXpos = self.view.frame.origin.x
        self.viewYpos = self.view.frame.origin.y
    }
    
    func resizeGradientBackgroundView() {
        self.gradientBackgroundView.frame = CGRect(
            x: self.viewXpos!,
            y: self.viewYpos!,
            width: self.viewWidth!,
            height: self.viewHeight! * 7
        )
    }
    
    func buttonRoundedUp() {
        self.startButton.layer.cornerRadius = self.startButton.frame.size.height / 2
        self.startButton.clipsToBounds = true
    }
    
    func addBlurEffectOnBlurView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.blurView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurView.addSubview(blurEffectView)
    }
    
    func addCircleIndicatorsOnDeepPointSliderview() {
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
            let gradientView = UIView(frame: CGRect(
                x: self.viewXpos!,
                y: self.viewHeight! * CGFloat(index),
                width: self.viewWidth!,
                height: self.viewHeight!
            ))
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = gradientView.bounds
            gradientLayer.colors = Depth(rawValue: index)?.toGradientColor()
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
    
    func updateJournal(contents: String, depth: Int, userId: Int, sentenceId: Int, emotionId: Int, wroteAt: String) {
        DiariesService.shared.postDiaries(contents: contents, depth: depth, userId: userId, sentenceId: sentenceId, emotionId: emotionId, wroteAt: wroteAt){
            (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let serverData = data as? CreateDiary {
                    print(serverData.id)
                    self.pushToDiaryViewController(diaryId: serverData.id)
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
    
    func pushToDiaryViewController(diaryId: Int) {
        let diaryStoryboard = UIStoryboard(name: Constants.Name.diaryStoryboard, bundle: nil)
        guard let diaryViewController = diaryStoryboard.instantiateViewController(identifier: Constants.Identifier.diaryViewController) as? DiaryViewController else { return }
        // TODO: - 서버에서 받아오기
        diaryViewController.diaryId = diaryId
        diaryViewController.currentDepth = Depth(rawValue: Int(round(self.deepSliderValue * 6))) ?? Depth.depth2m
        self.navigationController?.pushViewController(diaryViewController, animated: true)
        
    }
    
    @IBAction func startButtonTouchUp(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else {
            return
        }
        if text == "시작하기" {
            self.pushToLoginViewController()
        } else if text == "기록하기" {
            guard let selectedMood = mood, let selectedSentence = sentence else {
                return
            }
            let dateArray = date.components(separatedBy: ". ")
            updateJournal(contents: journal,
                          depth: Int(round(self.deepSliderValue * 6)),
                          userId: Int(APIConstants.userId),
                          sentenceId: selectedSentence.id,
                          emotionId: selectedMood.rawValue,
                          wroteAt: "\(dateArray[0])-\(dateArray[1])-\(dateArray[2])")
        } else { // text == "수정하기"
            self.deepViewControllerDelegate?.passData(
                selectedDepth: Depth(rawValue: Int(round(self.deepSliderValue * 6))) ?? Depth.depth2m)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
}

extension DeepViewController: SliderDelegate {
    
    func deepPointSliderValueChanged(slider: UISlider) {
        self.sliderUpdated(slider, sliderValue: slider.value)
    }
    
    func deepLabelSliderValueChanged(slider: UISlider) {
        self.sliderUpdated(slider, sliderValue: slider.value)
    }
    
    func sliderUpdated(_ slider: UISlider, sliderValue: Float) {
        
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
