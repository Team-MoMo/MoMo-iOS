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
    var labelImages: [UIImage?] = [
        Constants.Design.Image.label2m,
        Constants.Design.Image.label30m,
        Constants.Design.Image.label100m,
        Constants.Design.Image.label300m,
        Constants.Design.Image.label700m,
        Constants.Design.Image.label1005m,
        Constants.Design.Image.labelDeepSea
    ]
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Functions
    
    static func instantiate(initialDepth: Depth) -> DeepSliderView? {
        
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
        let line = UIView(frame: CGRect(x: 0, y: 0, width: 105, height: 0.5))
        line.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        let lineImage = line.asImage()
        let rotatedImage = lineImage.rotate(radians: -(.pi / 2))
        deepSliderView?.deepLineSlider.setThumbImage(rotatedImage, for: .normal)
        
        // deepLabelSlider 설정
        deepSliderView?.deepLabelSlider.setValue(initialSliderValue, animated: false)
        deepSliderView?.deepLabelSlider.minimumTrackTintColor = UIColor.white.withAlphaComponent(0)
        deepSliderView?.deepLabelSlider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0)
        deepSliderView?.deepLabelSlider.setThumbImage(deepSliderView?.labelImages[initialDepth.rawValue], for: .normal)
        
        return deepSliderView
    }
    
    @IBAction func deepLabelSliderValueChanged(_ sender: UISlider) {
        self.sliderDelegate?.deepLabelSliderValueChanged(slider: sender)
    }
    
    @IBAction func deepPointSliderValueChanged(_ sender: UISlider) {
        self.sliderDelegate?.deepLabelSliderValueChanged(slider: sender)
    }
}
