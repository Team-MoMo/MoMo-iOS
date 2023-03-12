//
//  CoachmarkSecondView.swift
//  MoMo
//
//  Created by 초이 on 2021/05/24.
//

import UIKit

class CoachmarkSecondView: UIView {
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var coachLabel01: UILabel!
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeLabel()
    }
    
    // MARK: - Functions
    
    func initializeLabel() {
        let attributedString = NSMutableAttributedString(string: "아래로 스크롤하면\n나만의 바다를 만날 수 있어요!", attributes: [
          .font: UIFont(name: "AppleSDGothicNeo-Light", size: 17.0)!,
          .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
          .kern: -0.6
        ])
        attributedString.addAttribute(.font, value: UIFont(name: "AppleSDGothicNeo-Regular", size: 17.0)!, range: NSRange(location: 0, length: 3))
        attributedString.addAttribute(.font, value: UIFont(name: "AppleSDGothicNeo-Bold", size: 17.0)!, range: NSRange(location: 3, length: 4))
        
        coachLabel01.attributedText = attributedString
    }
    
}
