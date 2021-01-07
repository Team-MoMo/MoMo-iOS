//
//  String+Extension.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/08.
//

import Foundation

extension String {
    // 자간 설정
    func wordSpacing(_ spacing: Float) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
}
