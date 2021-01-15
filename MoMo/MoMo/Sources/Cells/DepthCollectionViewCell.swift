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
    
    func setLabel(_ depth: String) {
        depthLabel.text = depth
    }

}
