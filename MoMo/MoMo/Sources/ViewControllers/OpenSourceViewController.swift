//
//  OpenSourceViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/02/04.
//

import UIKit

class OpenSourceViewController: UIViewController {
    
    // MARK: - Constants
    let openSourceTitle: [String] = ["SwiftLint",
                                    "AlamoFire",
                                    "Moya",
                                    "Lottie",
                                    "SnapKit",
                                    "IQKeyboardManager",
                                    "CLTypingLabel"]
    
    // MARK: - Properties
    private lazy var navigationBarTitleLabel: UILabel = {
        let label = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.Black2Nav,
                                                         NSAttributedString.Key.kern: -0.6]
        label.attributedText = NSAttributedString(string: "오픈소스 라이선스", attributes: attributes)
        label.sizeToFit()
        return label
    }()

    // MARK: - IBOutlets
    @IBOutlet weak var openSourceTableView: UITableView!
    
    // MARK: - Override LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        assginDelegate()
        assignDataSource()
        registerCellXib()
        initializeNavigationItem()
    }
    
    //MARK: - Private Function
    private func registerCellXib() {
        openSourceTableView.register(UINib(nibName: "OpenSourceTableViewCell", bundle: nil), forCellReuseIdentifier: "OpenSourceTableViewCell")
    }
    
    private func initializeTableView() {
        openSourceTableView.separatorStyle = .none
    }
    
    private func assginDelegate() {
        openSourceTableView.delegate = self
    }
    
    private func assignDataSource() {
        openSourceTableView.dataSource = self
    }
    
    private func initializeNavigationItem() {
        let backButton = UIBarButtonItem(image: Constants.Design.Image.btnBackBlack, style: .plain, target: self, action: #selector(dismissOpenSourceView))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.titleView = self.navigationBarTitleLabel
    }
    
    // MARK: - Selector Function
    @objc func dismissOpenSourceView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func pushToOpenSourceDetailView(_ sender: UIButton) {
        print(sender.tag)
    }
}

extension OpenSourceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
}
extension OpenSourceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openSourceTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OpenSourceTableViewCell") as? OpenSourceTableViewCell else {
            return UITableViewCell()
        }
        cell.detailButton.tag = indexPath.row
        cell.detailButton.addTarget(self, action: #selector(pushToOpenSourceDetailView(_:)), for: .touchUpInside)
        cell.initializeLabel(openSourceTitle[indexPath.row])
        return cell
        
    }
    
    
}
