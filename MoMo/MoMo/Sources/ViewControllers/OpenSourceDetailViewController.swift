//
//  OpenSourceDetailViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/02/04.
//

import UIKit

class OpenSourceDetailViewController: UIViewController {
    
    // MARK: - Properties
    var openSourceDetailData: String = ""
    private lazy var navigationBarTitleLabel: UILabel = {
        let label = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.Black2Nav,
                                                         NSAttributedString.Key.kern: -0.6]
        label.attributedText = NSAttributedString(string: "오픈소스 라이선스", attributes: attributes)
        label.sizeToFit()
        return label
    }()
    
    // MARK: - IBOutlets
    @IBOutlet weak var openSourceDetailTextView: UITextView!
    
    // MARK: - Override LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeNavigationItem()
        initializeTextView()
    }
    
    // MARK: - Functions
    func initializeTextView() {
        let attributedString = NSMutableAttributedString(string: openSourceDetailData)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.kern, value: -0.6, range: NSRange(location: 0, length: attributedString.length))
        
        self.openSourceDetailTextView.attributedText = attributedString
    }
    
    // MARK: - Private Functions
    private func initializeNavigationItem() {
        let backButton = UIBarButtonItem(image: Constants.Design.Image.btnBackBlack, style: .plain, target: self, action: #selector(dismissOpenSourceDetailView))
        backButton.tintColor = UIColor.Black1
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.titleView = self.navigationBarTitleLabel
    }
    
    // MARK: - Selector Functions
    @objc func dismissOpenSourceDetailView() {
        self.navigationController?.popViewController(animated: true)
    }
}
