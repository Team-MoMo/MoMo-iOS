//
//  DeepSliderView.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/11.
//

import UIKit

protocol SliderDelegate: class {
    func deepPointSliderValueChanged(slider: UISlider)
    func deepLabelSliderValueChanged(slider: UISlider)
}

class DeepSliderView: UIView {

    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var deepLabelSlider: UISlider!
    @IBOutlet weak var deepLineSlider: UISlider!
    @IBOutlet weak var deepPointSlider: UISlider!
    
    // MARK: - Properties
    
    weak var sliderDelegate: SliderDelegate!
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Functions
    
    static func instantiate(initialDepth: AppDepth) -> DeepSliderView? {
        
        let deepSliderView: DeepSliderView? = initFromNib()
        let initialSliderValue: Float = Float(initialDepth.rawValue) / 6
        
        // deepSliderView 세로로 뒤집기
        deepSliderView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        
        // deepPointSlider 설정
        deepSliderView?.deepPointSlider.setThumbImage(Constants.Design.Image.icStep, for: .normal)
        deepSliderView?.deepPointSlider.setValue(initialSliderValue, animated: false)
        deepSliderView?.deepPointSlider.minimumTrackTintColor = UIColor.white.withAlphaComponent(0)
        deepSliderView?.deepPointSlider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0)
        deepSliderView?.deepPointSlider.addTapGesture()
        
        // deepLineSlider 설정
        deepSliderView?.deepLineSlider.setValue(initialSliderValue, animated: false)
        deepSliderView?.deepLineSlider.minimumTrackTintColor = UIColor.white.withAlphaComponent(0)
        deepSliderView?.deepLineSlider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0)
        deepSliderView?.deepLineSlider.setThumbImage(Constants.Design.Image.deepLine, for: .normal)
        
        // deepLabelSlider 설정
        deepSliderView?.deepLabelSlider.setValue(initialSliderValue, animated: false)
        deepSliderView?.deepLabelSlider.minimumTrackTintColor = UIColor.white.withAlphaComponent(0)
        deepSliderView?.deepLabelSlider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0)
        deepSliderView?.deepLabelSlider.setThumbImage(initialDepth.toLabelImage(), for: .normal)
        
        return deepSliderView
    }
    
    @IBAction func deepLabelSliderValueChanged(_ sender: UISlider) {
        self.sliderDelegate?.deepLabelSliderValueChanged(slider: sender)
    }
    
    @IBAction func deepPointSliderValueChanged(_ sender: UISlider) {
        self.sliderDelegate?.deepLabelSliderValueChanged(slider: sender)
    }
}
