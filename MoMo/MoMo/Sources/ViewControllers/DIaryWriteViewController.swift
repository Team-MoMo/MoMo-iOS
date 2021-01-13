//
//  DiaryWriteViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/10.
//

import UIKit

class DiaryWriteViewController: UIViewController {
    
    // MARK: - Properties
    
    var date: String = "2020. 12. 26 토요일"
    var emotionOriginalImage: UIImage = UIImage()
    var emotion: String = "화남"
    var author: String = "구병모"
    var book: String = "파괴"
    var publisher: String = "위즈덤 하우스"
    var quote: String = "접입가경, 이게 웬 심장이 콧구멍으로 쏟아질 얘긴가 싶지만 그저 지레짐작이나 얻어걸린 이야기일 가능성이 더 많으니 조각은 표정을 바꾸지 않는다."
    var journal: String = ""
    var placeHolder: NSMutableAttributedString = NSMutableAttributedString()
    var alertModalView: AlertModalView?
    
    // MARK: - IBOutlet
    
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
        setWordSpace()
        setNavigationButton()
        setAlertModal()
        }
    
    // MARK: - IBAction
    
    @IBAction func tapBackground(_ sender: Any) {
        self.journalTextView.endEditing(true)
    }
    
    @IBAction func touchMoreButton(_ sender: Any) {
        shrinkQuoteLabel()
    }
    
    // MARK: - Private function for settings
    
    func setAlertModal() {
        let attributedString = NSMutableAttributedString(string: "확인")
    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1.0), range: NSRange(location: 0, length: attributedString.length))
        self.alertModalView = AlertModalView.instantiate(
            alertLabelText: "작성한 일기가 저장되지 않습니다.\n정말 뒤로 가시겠어요?",
            leftButtonTitle: NSMutableAttributedString(string: "취소"),
            rightButtonTitle: attributedString
        )
    }
    
    func attachAlertModalView() {
        if let alertModalView = self.alertModalView {
            alertModalView.alertModalDelegate = self
            self.view.insertSubview(alertModalView, aboveSubview: self.view)
            alertModalView.setConstraints(view: alertModalView, superView: self.view)
        }
    }
    
    func setNavigationButton() {
        self.navigationItem.hidesBackButton = true

        let rightButton = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(touchNextButton))
        self.navigationItem.rightBarButtonItems = [rightButton]
        let leftButton = UIBarButtonItem(image: Constants.Design.Image.btnBackBlack, style: .plain, target: self, action: #selector(touchBackButton))
        leftButton.tintColor = .black
        self.navigationItem.leftBarButtonItems = [leftButton]
    }
    
    @objc func touchNextButton() {
        let writeStorybaord = UIStoryboard(name: Constants.Name.onboardingStoryboard, bundle: nil)
        guard let deepViewController = writeStorybaord.instantiateViewController(identifier: Constants.Identifier.deepViewController) as? DeepViewController else {
            return
        }
        deepViewController.buttonText = "기록하기"
        self.navigationController?.pushViewController(deepViewController, animated: true)

    }
    
    @objc func touchBackButton() {
        self.attachAlertModalView()
    }
    
    private func setWordSpace() {
        dateLabel.attributedText = date.wordSpacing(-0.6)
        emotionImage.image = emotionOriginalImage
        emotionLabel.attributedText = emotion.wordSpacing(-0.6)
        authorLabel.attributedText = author.wordSpacing(-0.6)
        bookLabel.attributedText = "<\(book)>".wordSpacing(-0.6)
        publisherLabel.attributedText = "(\(publisher))".wordSpacing(-0.6)
        
        let attributedString = NSMutableAttributedString(string: quote)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: -0.6, range: NSRange(location: 0, length: attributedString.length))
        let paragraphStyle = NSMutableParagraphStyle()
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        paragraphStyle.lineSpacing = 4
        
        quoteLabel.attributedText = attributedString
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
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.Black3List]
        
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

// MARK: - UITextViewDelegate

extension DiaryWriteViewController: UITextViewDelegate {
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

extension DiaryWriteViewController: AlertModalDelegate {
    
    func leftButtonTouchUp(button: UIButton) {
        self.alertModalView?.removeFromSuperview()
    }
    
    func rightButtonTouchUp(button: UIButton) {
        self.alertModalView?.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }
}
