//
//  ToastView.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/02/02.
//

import UIKit

class ToastView: UIView {
    
    @IBOutlet weak var toastViewContainer: UIView!
    @IBOutlet weak var toastMessage: UILabel!
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Functions
    
    static func instantiate(message: String) -> ToastView? {
        
        let toastView: ToastView? = initFromNib()
        toastView?.toastViewContainer.round(corners: UIRectCorner.allCorners, cornerRadius: Double(toastView?.toastViewContainer.frame.size.height ?? 48 / 2))
        toastView?.toastMessage.attributedText = message.textSpacing()
        
        return toastView
    }
}
