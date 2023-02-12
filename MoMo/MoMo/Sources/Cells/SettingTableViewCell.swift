//
//  SettingTableViewCell.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/02/02.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableCellImage: UIImageView!
    @IBOutlet weak var tableCellLabel: UILabel!
    
    // MARK: - Properties
    
    // MARK: - View Life Cycles
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView?.isHidden = true
        self.backgroundColor = .white
    }
    
    // MARK: - Functions
    
    func setCell(image: UIImage?, labelText: String) {
        if image == nil {
            self.tableCellImage.isHidden = true
        } else {
            self.tableCellImage.isHidden = false
            self.tableCellImage.image = image
        }
        self.tableCellLabel.attributedText = labelText.textSpacing()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }
}
    
