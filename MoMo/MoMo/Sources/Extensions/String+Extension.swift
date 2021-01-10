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
    // 앱 내 모든 자간 -0.6으로 통일, 행간은 Int값으로 지정 가능
    func textSpacing(lineSpacing: Int) {
        let attributedString = NSMutableAttributedString(string: labelName.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = CGFloat(lineSpacing)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.kern, value: -0.6, range: NSRange(location: 0, length: attributedString.length))

        labelName.attributedText = attributedString
    }
}
