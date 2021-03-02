//
//  DiaryWriteViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/10.
//

import UIKit

protocol DiaryWriteViewControllerDelegate: class {
    func popToDiaryViewController(newDiaryInfo: AppDiary?)
}

enum DiaryWriteViewNavigationButton: Int {
    case leftButtonForDiary = 0, rightButtonForDiary, leftButtonForUpload, rightButtonForUpload
}

class DiaryWriteViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var emotionImage: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var featherImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var depthImage: UIImageView!
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var diaryWriteScrollView: UIScrollView!
    @IBOutlet weak var quoteLabelTopConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var isFromDiary: Bool = false
    var diaryInfo: AppDiary?
    private var initialDiaryInfo: AppDiary?
    private var toastView: ToastView?
    private var alertModalView: AlertModalView?
    private var placeHolder: NSAttributedString = {
        guard let font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 13) else {
            return NSAttributedString()
        }
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font,
                                                         NSAttributedString.Key.foregroundColor: UIColor.Blue3,
                                                         NSAttributedString.Key.kern: -0.6]
        return NSAttributedString(string: "파동을 충분히 느낀 후, 감정을 기록해보세요.", attributes: attributes)
    }()
    
    private let placeHolderText: String = "파동을 충분히 느낀 후, 감정을 기록해보세요."
    weak var diaryWriteViewControllerDelegate: DiaryWriteViewControllerDelegate?
    
    private lazy var leftButtonForDiary: UIBarButtonItem = {
        let button = UIBarButtonItem(image: Constants.Design.Image.btnBackWhite, style: .plain, target: self, action: #selector(touchNavigationButton(sender:)))
        button.tintColor = UIColor.Black1
        button.tag = DiaryWriteViewNavigationButton.leftButtonForDiary.rawValue
        return button
    }()
    
    private lazy var rightButtonForDiary: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(touchNavigationButton(sender:)))
        button.tag = DiaryWriteViewNavigationButton.rightButtonForDiary.rawValue
        button.tintColor = UIColor.Blue2
        return button
    }()
    
    private lazy var leftButtonForUpload: UIBarButtonItem = {
        let button = UIBarButtonItem(image: Constants.Design.Image.btnBackBlack, style: .plain, target: self, action: #selector(touchNavigationButton(sender:)))
        button.tag = DiaryWriteViewNavigationButton.leftButtonForUpload.rawValue
        button.tintColor = .black
        return button
    }()
    
    private lazy var rightButtonForUpload: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(touchNavigationButton(sender:)))
        button.tag = DiaryWriteViewNavigationButton.rightButtonForUpload.rawValue
        button.tintColor = UIColor.Blue3
        return button
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeNavigationBar()
        self.initializeDiaryWriteViewController()
        self.addTapGestureOnDiaryWriteScrollView()
    }
    
    // MARK: - Functions
    

    private func updateTextView() {
        guard let font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14) else {
            return
        }
        let spacing = NSMutableParagraphStyle()
        spacing.lineSpacing = 4
        
        self.journalTextView.typingAttributes = [NSAttributedString.Key.font: font,
                                                 NSAttributedString.Key.kern: -0.6,
                                                 NSAttributedString.Key.foregroundColor: UIColor.Black3List,
                                                 NSAttributedString.Key.paragraphStyle: spacing]
    }
    

    private func initializeDiaryWriteViewController() {
        self.journalTextView.delegate = self
        self.updateDiaryWriteViewController()
        if self.isFromDiary {
            self.depthImage.isHidden = false
            self.depthLabel.isHidden = false
            self.initialDiaryInfo = self.diaryInfo
        } else {
            self.depthImage.isHidden = true
            self.depthLabel.isHidden = true
            
            self.updatePlaceholder()
            self.journalTextView.attributedText = self.placeHolder
        }
    }
    
    private func initializeNavigationBar() {
        self.navigationItem.hidesBackButton = true
        if self.isFromDiary {
            self.navigationItem.leftBarButtonItem = self.leftButtonForDiary
        } else {
            self.navigationItem.rightBarButtonItem = self.rightButtonForUpload
            self.navigationItem.leftBarButtonItem = self.leftButtonForUpload
        }
    }
    
    private func addTapGestureOnDiaryWriteScrollView() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchDiaryScrollView))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.diaryWriteScrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    private func updateDiaryWriteViewController() {
        guard let date = diaryInfo?.date?.getFormattedDateAndWeekday(with: ". "),
              let emotion = self.diaryInfo?.mood?.toString(),
              let author = self.diaryInfo?.sentence?.author,
              let bookTitle = self.diaryInfo?.sentence?.bookTitle,
              let publisher = self.diaryInfo?.sentence?.publisher,
              let quote = self.diaryInfo?.sentence?.sentence else { return }
        
        self.dateLabel.attributedText = date.textSpacing()
        self.emotionImage.image = diaryInfo?.mood?.toIcon()
        self.emotionLabel.attributedText = emotion.textSpacing()
        self.authorLabel.attributedText = author.textSpacing()
        self.bookLabel.attributedText = "<\(bookTitle)>".textSpacing()
        self.publisherLabel.attributedText = "(\(publisher))".textSpacing()
        self.quoteLabel.attributedText = quote.textSpacing()
        
        if self.isFromDiary {
            self.depthLabel.text = diaryInfo?.depth?.toString()
            self.journalTextView.text = diaryInfo?.diary
        }
    }
    
    private func updatePlaceholder() {
        if let font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 13) {
            let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font,
                                                             NSAttributedString.Key.foregroundColor: UIColor.Blue3,
                                                             NSAttributedString.Key.kern: -0.6]
            placeHolder = NSAttributedString(string: self.placeHolderText, attributes: attributes)
        }
    }
    
    private func shrinkQuoteLabel() {
        if quoteLabel.text == "" {
            UIView.animate(withDuration: 0.5) {
                self.moreButton.transform = CGAffineTransform(rotationAngle: -.pi*2)
                self.quoteLabel.text = self.diaryInfo?.sentence?.sentence
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
    
    private func saveDiary() {
        self.diaryInfo?.diary = self.journalTextView.text
    }
    
    private func isDiaryChanged() -> Bool {
        guard let newDiary = self.diaryInfo?.diary, let oldDiary = self.initialDiaryInfo?.diary else { return false }
        return newDiary == oldDiary
    }
    
    private func popToSentenceViewControllerWithAlert() {
        if self.journalTextView.text != self.placeHolderText {
            self.attachAlertModalView()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func popToSentenceViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func popToDiaryViewController(save: Bool) {
        guard let textViewText = self.journalTextView.text else { return }
        if textViewText.isEmpty {
            self.attachToastViewWithAnimation()
        } else {
            if save { self.saveDiary() }
            self.navigationItem.rightBarButtonItem = nil
            self.diaryWriteViewControllerDelegate?.popToDiaryViewController(newDiaryInfo: self.diaryInfo)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func pushToDeepViewController() {
        guard let textViewText = self.journalTextView.text else { return }
        
        if textViewText.isEmpty || textViewText == self.placeHolderText {
            self.attachToastViewWithAnimation()
        } else {
            let onboardingStorybaord = UIStoryboard(name: Constants.Name.onboardingStoryboard, bundle: nil)
            guard let deepViewController = onboardingStorybaord.instantiateViewController(identifier: Constants.Identifier.deepViewController) as? DeepViewController else {
                return
            }
            self.saveDiary()
            deepViewController.diaryInfo = self.diaryInfo
            deepViewController.deepViewUsage = .upload
            self.navigationController?.pushViewController(deepViewController, animated: true)
        }
    }
    
    private func attachAlertModalView() {
        self.alertModalView = AlertModalView.instantiate(
            alertLabelText: "작성한 일기가 저장되지 않습니다.\n정말 뒤로 가시겠어요?",
            leftButtonTitle: "취소",
            rightButtonTitle: "확인"
        )

        if let alertModalView = self.alertModalView {
            alertModalView.alertModalDelegate = self
            self.view.insertSubview(alertModalView, aboveSubview: self.view)
            self.updateAlertModalViewConstraints(view: alertModalView)
        }
    }
    
    private func attachToastViewWithAnimation() {
        self.attachToastView()
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            animations: {
                self.toastView?.alpha = 1.0
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0.5,
                    animations: {
                        self.toastView?.alpha = 0.0
                    },
                    completion: { _ in
                        self.detachToastView()
                    }
                )
            }
        )
    }
    
    private func attachToastView() {
        self.toastView = ToastView.instantiate(message: "일기를 작성해 주세요!")
        guard let toastView = self.toastView else { return }
        toastView.alpha = 0.0
        self.view.insertSubview(toastView, aboveSubview: self.view)
        self.updateToastViewConstraints(view: toastView)
    }
    
    private func detachToastView() {
        self.toastView?.removeFromSuperview()
    }
    
    private func updateAlertModalViewConstraints(view: UIView) {
        view.snp.makeConstraints({ (make) in
            make.width.height.centerX.centerY.equalTo(self.view)
        })
    }
    
    private func updateToastViewConstraints(view: UIView) {
        view.snp.makeConstraints({ (make) in
            make.width.height.centerX.centerY.equalTo(self.view)
        })
    }
    
    @objc private func touchDiaryScrollView(sender: UITapGestureRecognizer) {
        self.journalTextView.becomeFirstResponder()
    }
    
    @IBAction func tapBackground(_ sender: Any) {
        self.journalTextView.endEditing(true)
    }
    
    @IBAction func touchMoreButton(_ sender: Any) {
        self.shrinkQuoteLabel()
    }
    
    @objc private func touchNavigationButton(sender: Any) {
        if let button = sender as? UIBarButtonItem {
            switch button.tag {
            case DiaryWriteViewNavigationButton.leftButtonForDiary.rawValue:
                self.isDiaryChanged() ? self.attachAlertModalView() : self.popToDiaryViewController(save: false)
            case DiaryWriteViewNavigationButton.rightButtonForDiary.rawValue:
                self.popToDiaryViewController(save: true)
            case DiaryWriteViewNavigationButton.leftButtonForUpload.rawValue:
                self.popToSentenceViewControllerWithAlert()
            case DiaryWriteViewNavigationButton.rightButtonForUpload.rawValue:
                self.pushToDeepViewController()
            default:
                return
            }
        }
    }
}

// MARK: - UITextViewDelegate

extension DiaryWriteViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if self.journalTextView.text == self.placeHolderText {
            self.journalTextView.text = ""
        }
        
        if self.quoteLabel.text == "" { return true }
        
        self.shrinkQuoteLabel()
        updateTextView()
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.journalTextView.text.isEmpty {
            self.journalTextView.attributedText = self.placeHolder
        }
        self.diaryInfo?.diary = self.journalTextView.text
        
        if self.isFromDiary {
            self.navigationItem.rightBarButtonItem = self.rightButtonForDiary
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if self.navigationItem.rightBarButtonItem == nil {
            self.navigationItem.rightBarButtonItem = self.rightButtonForDiary
        }
    }
}

// MARK: - AlertModalDelegate

extension DiaryWriteViewController: AlertModalDelegate {
    
    func leftButtonTouchUp(button: UIButton) {
        self.alertModalView?.removeFromSuperview()
    }
    
    func rightButtonTouchUp(button: UIButton) {
        self.alertModalView?.removeFromSuperview()
        if self.isFromDiary {
            self.popToDiaryViewController(save: false)
        } else {
            self.popToSentenceViewController()
        }
    }
}
