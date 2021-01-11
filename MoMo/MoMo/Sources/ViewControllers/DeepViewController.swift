//
//  DeepViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/10.
//

import UIKit
import SnapKit

class DeepViewController: UIViewController {

    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var gradientScrollView: UIScrollView!
    @IBOutlet weak var gradientBackgroundView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - Properties
    
    let dafaultInfoLabel: String = "오늘의 감정은\n잔잔한가요, 깊은가요?\n스크롤을 움직여서 기록해보세요"
    let gradientColors = [
        [UIColor.Gradient1.cgColor, UIColor.Gradient2.cgColor],
        [UIColor.Gradient2.cgColor, UIColor.Gradient3.cgColor],
        [UIColor.Gradient3.cgColor, UIColor.Gradient4.cgColor],
        [UIColor.Gradient4.cgColor, UIColor.Gradient5.cgColor],
        [UIColor.Gradient5.cgColor, UIColor.Gradient6.cgColor],
        [UIColor.Gradient6.cgColor, UIColor.Gradient7.cgColor],
        [UIColor.Gradient7.cgColor, UIColor.Gradient8.cgColor]
    ]
    var deepSliderView: DeepSliderView?
    var deepSliderValue: Float = 0
    var viewWidth: CGFloat?
    var viewHeight: CGFloat?
    var viewXpos: CGFloat?
    var viewYpos: CGFloat?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 임시
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.alpha = 0.0
        // 임시
        
        self.infoLabel.text = self.dafaultInfoLabel
        self.buttonRoundedUp()
        self.getViewContraints()
        self.resizeGradientBackgroundView()
        self.addBlurEffectOnBlurView()
        self.deepSliderView = DeepSliderView.instantiate()
        
        if let deepSliderView = self.deepSliderView {
            
            deepSliderView.sliderDelegate = self
            
            self.view.addSubview(deepSliderView)
            
            deepSliderView.snp.makeConstraints { (make) in
                make.height.equalTo(self.view.frame.size.width * 2)
                make.width.equalTo(self.view.frame.size.height * 0.6)
            }
            
            deepSliderView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.view.snp.leading).inset(47)
                make.centerY.equalTo(self.blurView).offset(-35)
            }
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addCircleIndicatorsOnDeepPointSliderview()
        self.addGradientOnGradientBackgroundView()
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
            gradientLayer.colors = self.gradientColors[index]
            gradientView.layer.addSublayer(gradientLayer)
            self.gradientBackgroundView.addSubview(gradientView)
        }
    }
    
    func pushToHomeViewController() {
        
        guard let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Identifier.homeViewController) as? HomeViewController else { return }
        
        self.navigationController?.pushViewController(homeViewController, animated: true)
        
    }
    
    @IBAction func startButtonTouchUp(_ sender: UIButton) {
        self.pushToHomeViewController()
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
        
        slider.isContinuous = true
        
        self.changeBackgroundWithAnimation(value: self.deepSliderValue)
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
                self.gradientBackgroundView.frame.origin.y = -CGFloat(self.deepSliderValue) * 6 * self.viewHeight!
            },
            completion: nil
        )
    }
    
    func labelChanged(value: Float) {
        deepSliderView?.deepLabelSlider.setThumbImage(deepSliderView?.labelImages[Int(value * 6)], for: .normal)
    }
}
