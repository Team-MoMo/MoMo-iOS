//
//  UIView+Extension.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/08.
//

import Foundation
import UIKit

extension UIView {
    // 선택한 꼭짓점 Rounding
    func round(corners: UIRectCorner, cornerRadius: Double) {
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
    }
}
