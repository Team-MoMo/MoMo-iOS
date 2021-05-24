//
//  CoachmarkFirst.swift
//  MoMo
//
//  Created by 초이 on 2021/05/24.
//

import UIKit

class CoachmarkFirstView: UIView {
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var coachLabel01: UILabel!
    @IBOutlet weak var coachLabel02: UILabel!
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeLabel()
    }
    
    // MARK: - Functions
    
    func initializeLabel() {
        let attributedString1 = NSMutableAttributedString(string: "모든 일기는\n여기서 한 번에 봐요", attributes: [ .font: UIFont.systemFont(ofSize: 17, weight: .light), .foregroundColor: UIColor(white: 1.0, alpha: 1.0), .kern: -0.6 ])
        attributedString1.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .bold), range: NSRange(location: 0, length: 5))
        
        let attributedString2 = NSMutableAttributedString(string: "새로운 일기를\n작성하세요!", attributes: [
          .font: UIFont.systemFont(ofSize: 17, weight: .light),
          .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
          .kern: -0.6
        ])
        attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .bold), range: NSRange(location: 0, length: 6))
        
        coachLabel01.attributedText = attributedString1
        coachLabel02.attributedText = attributedString2
    }
    
}
