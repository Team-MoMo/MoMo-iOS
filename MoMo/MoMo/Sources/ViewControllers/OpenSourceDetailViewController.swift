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
        guard let font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16) else {
            return UILabel()
        }
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font,
                                                         NSAttributedString.Key.foregroundColor: UIColor.Black2Nav,
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
        self.openSourceDetailTextView.attributedText = openSourceDetailData.wordTextSpacing(textSpacing: -0.6, lineSpacing: 4, center: false)
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
