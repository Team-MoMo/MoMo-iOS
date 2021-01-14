//
//  UITextField+Extension.swift
//  MoMo
//
//  Created by 초이 on 2021/01/13.
//

import UIKit

extension UITextField {
    func modifyClearButtonWithImage(image: UIImage) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:) ), for: .touchUpInside)
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
    }

    @objc func clear(sender: AnyObject) {
        self.text = ""
        sendActions(for: .editingChanged)
    }
}

