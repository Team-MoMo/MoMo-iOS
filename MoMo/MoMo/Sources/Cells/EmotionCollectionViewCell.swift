//
//  EmotionCollectionViewCell.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/05.
//

import UIKit

class EmotionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var emotionImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setImage(_ name: String) {
        self.emotionImage.image = UIImage(named: name)
    }

}
