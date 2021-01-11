//
//  UploadWriteViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/10.
//

import UIKit

class UploadWriteViewController: UIViewController {
    
    let quote: String = "접입가경, 이게 웬 심장이 콧구멍으로 쏟아질 얘긴가 싶지만 그저 지레짐작이나 얻어걸린 이야기일 가능성이 더 많으니 조각은 표정을 바꾸지 않는다."
    var journal: String = ""
    var placeHolder : NSMutableAttributedString = NSMutableAttributedString()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var emotionImage: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var featherImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var quoteLabelTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        journalTextView.delegate = self
        setPlaceholder()
        journalTextView.attributedText = placeHolder
    }
    
    @IBAction func tapBackground(_ sender: Any) {
        self.journalTextView.endEditing(true)
    }
    
    @IBAction func touchMoreButton(_ sender: Any) {
        shrinkQuoteLabel()
    }
    
    private func setPlaceholder() {
        let text = "파동을 충분히 느낀 후, 감정을 기록해보세요."
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: -0.6, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.Blue3, range: NSRange(location: 0, length: attributedString.length))
        self.placeHolder = attributedString

    }
    
    private func coordinateTextView() -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
    
        let attribute: [NSAttributedString.Key: Any] = [
            .kern: -0.6,
            .paragraphStyle: paragraphStyle]
        
        return attribute
    }
    
    private func shrinkQuoteLabel() {
        if quoteLabel.text == "" {
            UIView.animate(withDuration: 0.5) {
                self.moreButton.transform = CGAffineTransform(rotationAngle: -.pi*2)
                self.quoteLabel.text = self.quote
                self.quoteLabelTopConstraint.constant = 24
            }
            
        } else {
            UIView.animate(withDuration: 0.5) {
                self.moreButton.transform = CGAffineTransform(rotationAngle: .pi)
                self.quoteLabel.text = ""
                self.quoteLabelTopConstraint.constant = 0
            }
            
        }
    }
}

extension UploadWriteViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if journalTextView.text == "파동을 충분히 느낀 후, 감정을 기록해보세요." {
            journalTextView.text = ""
            journalTextView.typingAttributes = coordinateTextView()
        }
        if quoteLabel.text == "" {
            return true
        }
        shrinkQuoteLabel()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if journalTextView.text == ""{
            journalTextView.attributedText = placeHolder
        }
        journal = journalTextView.text
    }
}
