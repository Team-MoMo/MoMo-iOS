//
//  String+Extension.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/08.
//

import UIKit

extension String {
    // MARK: - TODO: 정엽오빠 코드 아래 textSpacing으로 리팩토링 후 지우기
    // 자간 설정
    func wordSpacing(_ spacing: Float) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
    // 자간, 행간 지정
    // 자간: -0.6 (앱 내 모든 자간 통일) , 행간: Zeplin Height - Font Height
    func textSpacing() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.kern, value: -0.6, range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
    
    func wordTextSpacing(textSpacing: Float, lineSpacing: Float, center: Bool, truncated: Bool) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 4
        if center {
            paragraphStyle.alignment = .center
        }
        if truncated {
            paragraphStyle.lineBreakMode = .byTruncatingTail
        }
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.kern, value: -0.6, range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
}
