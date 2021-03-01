//
//  DepthCollectionViewCell.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/05.
//

import UIKit

class DepthCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var depthLabel: UILabel!

    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backView.layer.borderColor = UIColor.Blue2.cgColor
                depthLabel.textColor = UIColor.Blue2
                backView.backgroundColor = UIColor.Blue6
            } else {
                backView.layer.borderColor = UIColor.Black6.cgColor
                depthLabel.textColor = UIColor.Black6
                backView.backgroundColor = UIColor.white
            }
        }
    }
    
    func initializeLabel(_ depth: String) {
        depthLabel.attributedText = depth.textSpacing()
    }

}
