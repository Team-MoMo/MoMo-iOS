//
//  UploadWriteViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/10.
//

import UIKit

class UploadWriteViewController: UIViewController {
    
    let quote: String = "접입가경, 이게 웬 심장이 콧구멍으로 쏟아질 얘긴가 싶지만 그저 지레짐작이나 얻어걸린 이야기일 가능성이 더 많으니 조각은 표정을 바꾸지 않는다."
    
    @IBOutlet weak var uploadTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        uploadTableView.delegate = self
        uploadTableView.dataSource = self
        uploadTableView.separatorStyle = .none
    }
    
    private func registerNib() {
        let nibHeader = UINib(nibName: "UploadTableViewHeaderView", bundle: nil)
        uploadTableView.register(nibHeader, forHeaderFooterViewReuseIdentifier: "UploadTableViewHeaderView")
        let nibFirstCell = UINib(nibName: "UploadQuoteTableViewCell", bundle: nil)
        uploadTableView.register(nibFirstCell, forCellReuseIdentifier: "UploadQuoteTableViewCell")
    }
    
    @objc func touchMoreButton(_ sender: UIButton) {
        
    }
}

extension UploadWriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UploadQuoteTableViewCell") as? UploadQuoteTableViewCell else {
                return UITableViewCell()
            }
            cell.moreButton.addTarget(self, action: #selector(touchMoreButton(_:)), for: .touchUpInside)
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "UploadTableViewHeaderView") as? UploadTableViewHeaderView else {
            return UIView()
        }
        header.layer.borderWidth = 1
        header.layer.borderColor = UIColor.black.cgColor
        return header
        
    }
    
}

extension UploadWriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
}
