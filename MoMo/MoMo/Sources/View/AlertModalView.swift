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
        
        alertModalView?.leftButton.setTitle(leftButtonTitle, for: .normal)
        alertModalView?.rightButton.setTitle(rightButtonTitle, for: .normal)
        alertModalView?.alertLabel.text = alertLabelText
        alertModalView?.modalContainerView.layer.cornerRadius = 10
        alertModalView?.modalContainerView.clipsToBounds = true
        alertModalView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        return alertModalView
    }
    
    func setConstraints(view: UIView, superView: UIView) {
        view.snp.makeConstraints({ (make) in
            make.width.equalTo(superView)
            make.height.equalTo(superView)
            make.centerX.equalTo(superView)
            make.centerY.equalTo(superView)
        })
    }
    
    @IBAction func leftButtonTouchUp(_ sender: UIButton) {
        self.alertModalDelegate?.leftButtonTouchUp(button: sender)
    }
    
    @IBAction func rightButtonTouchUp(_ sender: UIButton) {
        self.alertModalDelegate?.rightButtonTouchUp(button: sender)
    }
}
