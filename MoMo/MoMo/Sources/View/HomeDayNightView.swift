//
//  HomeDayNightView.swift
//  MoMo
//
//  Created by 초이 on 2021/01/08.
//

import UIKit

class HomeDayNightView: UIView {
    
    // TODO: - noDiaryStackView, filledDiaryView y축 autolayout은 나중에 오브제 나오면 오브제 중 구름에 맞춰야 함

    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var backgroundView: UIView!
    
    // empty view
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noDiaryStackView: UIStackView!
    
    // filled view
    @IBOutlet weak var emotionImageView: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var diaryLabel: UILabel!
    @IBOutlet weak var filledDiaryView: UIView!
    
    // MARK: - Properties
    
    var gradientLayer: CAGradientLayer!
    
    // MARK: - Functions
    
    // gradient 생성 후 배경 지정
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.backgroundView.bounds
        gradientLayer.colors = [UIColor.HomeDay1.cgColor, UIColor.HomeDay2.cgColor]
        self.backgroundView.layer.addSublayer(gradientLayer)
    }
    
    func textSpacing(labelName: UILabel, lineSpacing: Int) {
        let attributedString = NSMutableAttributedString(string: labelName.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = CGFloat(lineSpacing)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.kern, value: -0.6, range: NSRange(location: 0, length: attributedString.length))

        labelName.attributedText = attributedString
    }
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // gradient 배경 지정
        createGradientLayer()
        
        // TODO: - 줄 간격, 자간 extension으로 빼기 - 리팩토링 필요
        // 자간은 앱 내 통일이나, 행간은 다름
        
        textSpacing(labelName: dateLabel, lineSpacing: 7)
        textSpacing(labelName: emotionLabel, lineSpacing: 10)
        textSpacing(labelName: depthLabel, lineSpacing: 10)
        textSpacing(labelName: quoteLabel, lineSpacing: 10)
        textSpacing(labelName: writerLabel, lineSpacing: 10)
        textSpacing(labelName: bookTitleLabel, lineSpacing: 10)
        textSpacing(labelName: publisherLabel, lineSpacing: 10)
        textSpacing(labelName: diaryLabel, lineSpacing: 10)
        
    }

}
