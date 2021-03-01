//
//  OpenSourceTableViewCell.swift
//  MoMo
//
//  Created by 이정엽 on 2021/02/04.
//

import UIKit

class OpenSourceTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func initializeLabel(_ text: String) {
        self.titleLabel.attributedText = text.textSpacing(lineSpacing: 4)
    }
    
}
