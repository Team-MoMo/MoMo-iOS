//
//  HomeDayNightView.swift
//  MoMo
//
//  Created by 초이 on 2021/01/08.
//

import UIKit

class HomeDayNightView: UIView {

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
    
    func createGradientLayer() {
            gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.backgroundView.bounds
            gradientLayer.colors = [UIColor.HomeDay1.cgColor, UIColor.HomeDay2.cgColor]
            self.backgroundView.layer.addSublayer(gradientLayer)
    }
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("asd")
        createGradientLayer()
    }

}
