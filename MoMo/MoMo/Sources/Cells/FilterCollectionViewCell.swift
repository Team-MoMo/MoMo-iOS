//
//  FilterCollectionViewCell.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/05.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var filterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setFilterLabel(_ filter: String) {
        filterLabel.text = filter
    }
    
}
