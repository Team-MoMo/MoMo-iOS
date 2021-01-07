//
//  ListTableViewCell.swift
//  MoMo
//
//  Created by 이정엽 on 2020/12/29.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var journalView: UIView!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var journalLabel1: UILabel!
    @IBOutlet weak var journalLabel2: UILabel!
    
    // 재사용할 때
    override func prepareForReuse() {
        super.prepareForReuse()
        journalLabel1.layer.sublayers = nil
        journalLabel2.layer.sublayers = nil
        journalLabel1.text = ""
        journalLabel2.text = ""
        categoryLabel.text = ""
        dateLabel.text = ""
        dayLabel.text = ""
        depthLabel.text = ""
        quoteLabel.text = ""
        authorLabel.text = ""
        titleLabel.text = ""
        publisherLabel.text = ""
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // 리스트테이블뷰셀 데이터 입력
    func setCell(list: List) {
        iconImage.image = list.makeImage()
        categoryLabel.attributedText = list.category.wordSpacing(-0.6)
        dateLabel.attributedText = list.date.wordSpacing(-0.6)
        dayLabel.attributedText = list.day.wordSpacing(-0.6)
        depthLabel.attributedText = list.depth.wordSpacing(-0.6)
        authorLabel.attributedText = list.author.wordSpacing(-0.6)
        titleLabel.attributedText = list.title.wordSpacing(-0.6)
        publisherLabel.attributedText = list.publisher.wordSpacing(-0.6)
        }
    
    // 문구 텍스트 작업
    func quoteSpacing(_ text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.kern, value: -0.6, range: NSRange(location: 0, length: attributedString.length))

        quoteLabel.attributedText = attributedString
    }
    
    // 일기 분리 작업
    func journaltext(_ text: String, _ size: CGFloat) {
        let labelSize: CGSize = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 13, weight: .regular)])
        let verify = "힣".size(withAttributes: [.font: UIFont.systemFont(ofSize: 12, weight: .regular)]).width
        let breakpoint: Int
        
        if labelSize.width > size {
            breakpoint = Int(size/verify)+1
            let breakIndex: String.Index = text.index(text.startIndex, offsetBy: breakpoint)
            let firstString = NSMutableAttributedString(string: String(text[..<breakIndex]))
            let secondString = NSMutableAttributedString(string: String(text[breakIndex...]))
            firstString.addAttribute(NSAttributedString.Key.kern, value: -0.6, range: NSRange(location: 0, length: firstString.length))
            secondString.addAttribute(NSAttributedString.Key.kern, value: -0.6, range: NSRange(location: 0, length: secondString.length))
            
            journalLabel1.attributedText = firstString
            journalLabel2.attributedText = secondString
        } else {
            journalLabel1.attributedText = text.wordSpacing(-0.6)
        }
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        print(1)
    }
    
    // 일기 라벨에 밑줄 처리
    func setLabelUnderline(_ size1: CGFloat, _ size2: CGFloat) {
        DispatchQueue.main.async {
            let firstString = self.journalLabel1.text!
            let secondString = self.journalLabel2.text!
            let firstLabelSize: CGSize = firstString.size(withAttributes: [.font: UIFont.systemFont(ofSize: 12, weight: .regular)])
            let secondLabelSize: CGSize = secondString.size(withAttributes: [.font: UIFont.systemFont(ofSize: 12, weight: .regular)])

            let border1 = CALayer()
            let border2 = CALayer()
            
            border1.frame = CGRect(x: 0, y: Int(self.journalLabel1.frame.height) - 1, width: Int(firstLabelSize.width), height: 1)
            border1.backgroundColor = UIColor.LineLightGray.cgColor
            
            if secondLabelSize.width < size2 {
                border2.frame = CGRect(x: 0, y: self.journalLabel2.frame.height - 1, width: secondLabelSize.width, height: 1)
            } else {
                border2.frame = CGRect(x: 0, y: self.journalLabel2.frame.height - 1, width: size2, height: 1)
            }
            border2.backgroundColor = UIColor.LineLightGray.cgColor

            self.journalLabel1.layer.addSublayer(border1)
            self.journalLabel2.layer.addSublayer(border2)
        }
    }

}
