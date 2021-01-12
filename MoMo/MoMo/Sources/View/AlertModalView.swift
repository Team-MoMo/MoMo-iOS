//
//  AlertModal.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/12.
//

import UIKit

protocol AlertModalDelegate: class {
    func cancelButtonTouchUp(button: UIButton)
    func deleteButtonTouchUp(button: UIButton)
}

class AlertModalView: UIView {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
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
    
    static func instantiate() -> AlertModalView? {
        
        let alertModalView: AlertModalView? = initFromNib()
        
        alertModalView?.modalContainerView.layer.cornerRadius = 10
        alertModalView?.modalContainerView.clipsToBounds = true
        alertModalView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        return alertModalView
    }
    @IBAction func cancelButtonTouchUp(_ sender: UIButton) {
        self.alertModalDelegate?.cancelButtonTouchUp(button: sender)
    }
    @IBAction func deleteButtonTouchUp(_ sender: UIButton) {
        self.alertModalDelegate?.deleteButtonTouchUp(button: sender)
    }
}
