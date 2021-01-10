//
//  UploadWriteViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/10.
//

import UIKit

class UploadWriteViewController: UIViewController {
    
    let quote: String = "접입가경, 이게 웬 심장이 콧구멍으로 쏟아질 얘긴가 싶지만 그저 지레짐작이나 얻어걸린 이야기일 가능성이 더 많으니 조각은 표정을 바꾸지 않는다."
    private var height: CGFloat = 0.0
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
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        height = self.view.frame.height
    }
    @IBAction func tapBackground(_ sender: Any) {
        self.journalTextView.endEditing(true)
    }
    
    @IBAction func touchMoreButton(_ sender: Any) {
        shrinkQuoteLabel()
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

        if journalTextView.text == "" {
            return true
        }
        shrinkQuoteLabel()
        return true
    }
}
