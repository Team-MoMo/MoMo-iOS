//
//  UISlider+Extension.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/11.
//

import UIKit

extension UISlider {
    
    public func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        addGestureRecognizer(tap)
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        let percent = minimumValue + Float(location.x / bounds.width) * maximumValue
        setValue(percent, animated: false)
        sendActions(for: .valueChanged)
    }
    
}
