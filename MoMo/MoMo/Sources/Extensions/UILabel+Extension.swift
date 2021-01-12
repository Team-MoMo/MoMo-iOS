//
//  UILabel+Extension.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/09.
//

import UIKit

extension UILabel {
    
    func startBlink() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: [.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
            animations: { self.alpha = 0 },
            completion: nil
        )
    }
    
    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}
