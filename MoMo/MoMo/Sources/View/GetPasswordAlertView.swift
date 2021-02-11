//
//  getPasswordAlertView.swift
//  MoMo
//
//  Created by 초이 on 2021/02/08.
//

import UIKit

class GetPasswordAlertView: UIView {
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var modalLabel: UILabel!
    @IBOutlet weak var countImageView: UIImageView!
    
    @IBOutlet weak var modalLabelTop: NSLayoutConstraint!
    
    // MARK: - Constants
    let errorModelLabelTop: CGFloat = 49
    let countModelLabelTop: CGFloat = 32
    
    // MARK: - View Cycle
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Functions
    
    func showError() {
        iconImageView.image = Constants.Design.Image.modalIcWarning
        modalLabelTop.constant = errorModelLabelTop
        countImageView.isHidden = true
        
        modalLabel.text = """
        오늘 임시비밀번호를 모두 받으셨어요
        내일 다시 시도해주세요
        """
    }
    
    func showOnce() {
        iconImageView.image = Constants.Design.Image.modalIcCheck
        modalLabelTop.constant = countModelLabelTop
        countImageView.isHidden = false
        countImageView.image = Constants.Design.Image.icCount1
        
        modalLabel.text = """
        이메일에서 임시 비밀번호를 확인하세요
        하루에 3회만 받을 수 있어요!
        """
    }
    
    func showTwice() {
        iconImageView.image = Constants.Design.Image.modalIcCheck
        modalLabelTop.constant = countModelLabelTop
        countImageView.isHidden = false
        countImageView.image = Constants.Design.Image.icCount2
        
        modalLabel.text = """
        이메일에서 임시 비밀번호를 확인하세요
        하루에 3회만 받을 수 있어요!
        """
    }
    
    func showThrice() {
        iconImageView.image = Constants.Design.Image.modalIcCheck
        modalLabelTop.constant = countModelLabelTop
        countImageView.isHidden = false
        countImageView.image = Constants.Design.Image.icCount3
        
        modalLabel.text = """
        이메일에서 임시 비밀번호를 확인하세요
        하루에 3회만 받을 수 있어요!
        """
    }
}
