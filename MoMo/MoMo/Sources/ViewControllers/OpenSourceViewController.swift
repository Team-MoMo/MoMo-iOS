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
                                     "CLTypingLabel",
                                     "KakaoSDKCommon",
                                     "KakaoSDKAuth"]
    let openSourceDetail: [String] = [
        """
https://github.com/realm/SwiftLint
https://realm.github.io/SwiftLint/
The MIT License (MIT)
Copyright (c) 2020 Realm Inc.
""",
        """
https://github.com/Alamofire/Alamofire
http://alamofire.org
The MIT License (MIT)
 Copyright (c) 2014-2020 Alamofire Software Foundation (http://alamofire.org/)
""",
        """
https://github.com/Moya/Moya
The MIT License (MIT)
Copyright (c) 2014-present Artsy, Ash Furrow
""",
        """
https://github.com/airbnb/lottie-ios
Copyright 2018 Airbnb, Inc.
Apache License,Version 2.0
""",
        """
https://github.com/SnapKit
The MIT License (MIT)
Copyright (c) 2011-Present SnapKit Team
""",
        """
https://github.com/hackiftekhar/IQKeyboardManager
MIT License
Copyright (c) 2013-2017 Iftekhar Qurashi
""",
        """
https://github.com/cl7/CLTypingLabel
MIT License
Copyright (c) 2016 Chenglin Liu
""",
        """
https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKAuth/index.html
Copyright (c) 2021 Kakao Corp
""",
        """
    https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKCommon/Classes/KakaoSDKCommon.html
    Copyright (c) 2021 Kakao Corp
    """]
    
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
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assginDelegate()
        assignDataSource()
        registerCellXib()
        initializeNavigationItem()
        initializeTableView()
    }
    
    // MARK: - Functions
    
    private func registerCellXib() {
        openSourceTableView.register(UINib(nibName: "OpenSourceTableViewCell", bundle: nil), forCellReuseIdentifier: "OpenSourceTableViewCell")
    }
    
    private func initializeTableView() {
        openSourceTableView.backgroundColor = .white
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
        backButton.tintColor = UIColor.Black1
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.titleView = self.navigationBarTitleLabel
    }
    
    @objc func dismissOpenSourceView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func pushToOpenSourceDetailView(_ sender: UIButton) {
        guard let openSourceDetailViewController = storyboard?.instantiateViewController(identifier: "OpenSourceDetailViewController") as? OpenSourceDetailViewController else {
            return
        }
        openSourceDetailViewController.openSourceDetailData = self.openSourceDetail[sender.tag]
        self.navigationController?.pushViewController(openSourceDetailViewController, animated: true)
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
