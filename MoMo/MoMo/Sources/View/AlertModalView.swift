//
//  AlertModal.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/12.
//

import UIKit
import SnapKit

protocol AlertModalDelegate: class {
    func leftButtonTouchUp(button: UIButton)
    func rightButtonTouchUp(button: UIButton)
}

class AlertModalView: UIView {
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var modalContainerView: UIView!
    
    weak var alertModalDelegate: AlertModalDelegate?
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Functions
    
    static func instantiate(alertLabelText: String, leftButtonTitle: String, rightButtonTitle: String) -> AlertModalView? {
        
        let alertModalView: AlertModalView? = initFromNib()
        
        let leftButtonTitleText = leftButtonTitle.textSpacing()
        let rightButtonTitleText = rightButtonTitle.textSpacing()
        rightButtonTitleText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.AlertRightButtonGray, range: NSRange(location: 0, length: rightButtonTitleText.length))
        
        alertModalView?.leftButton.setAttributedTitle(leftButtonTitleText, for: .normal)
        alertModalView?.rightButton.setAttributedTitle(rightButtonTitleText, for: .normal)
        alertModalView?.alertLabel.attributedText = alertLabelText.wordTextSpacing(textSpacing: -0.6, lineSpacing: 4, center: true, truncated: false)
        alertModalView?.modalContainerView.layer.cornerRadius = 10
        alertModalView?.modalContainerView.clipsToBounds = true
        alertModalView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        return alertModalView
    }
    
    @IBAction func leftButtonTouchUp(_ sender: UIButton) {
        self.alertModalDelegate?.leftButtonTouchUp(button: sender)
    }
    
    @IBAction func rightButtonTouchUp(_ sender: UIButton) {
        self.alertModalDelegate?.rightButtonTouchUp(button: sender)
    }
}
