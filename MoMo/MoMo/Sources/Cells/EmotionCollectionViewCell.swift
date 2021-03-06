//
//  EmotionCollectionViewCell.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/05.
//

import UIKit

class EmotionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var emotionImage: UIImageView!
    
    var emotion: AppEmotion?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool {
      didSet {
        if isSelected {
            self.emotionImage.image = emotion?.toSelectedIcon()
        } else {
            self.emotionImage.image = emotion?.toUnselectedIcon()
        }
      }
    }
    
    func updateImage(_ image: UIImage) {
        self.emotionImage.image = image
    }

}
