//
//  ListTableViewCell.swift
//  MoMo
//
//  Created by 이정엽 on 2020/12/29.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    let icon: [UIImage] = [ Constants.Design.Image.icLoveBlue!,
                                 Constants.Design.Image.icHappyBlue!,
                                 Constants.Design.Image.icConsoleBlue!,
                                 Constants.Design.Image.icAngryBlue!,
                                 Constants.Design.Image.icSadBlue!,
                                 Constants.Design.Image.icBoredBlue!,
                                 Constants.Design.Image.icMemoryBlue!,
                                 Constants.Design.Image.icDailyBlue!,
    ]
    
    let emotion: [String] = ["사랑", "헹복", "위로", "화남", "슬픔", "우울", "추억", "일상"]
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
    @IBOutlet weak var moreButton: UIButton!
    
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
    func setCell(diary: Diary) {
        let date = diary.wroteAt.split(separator: "T")[0]
        let specificDate = date.split(separator: "-")
        iconImage.image = icon[diary.emotionID - 1]
        categoryLabel.attributedText = AppEmotion(rawValue: diary.emotionID)?.toString().wordSpacing(-0.6)
        dateLabel.attributedText = "\(specificDate[0])년 \(specificDate[1])월".wordSpacing(-0.6)
        dayLabel.attributedText = "\(specificDate[2])일".wordSpacing(-0.6)
        depthLabel.attributedText = AppDepth(rawValue: diary.depth)?.toString().wordSpacing(-0.6)
        authorLabel.attributedText = diary.sentence.writer.wordSpacing(-0.6)
        titleLabel.attributedText = diary.sentence.bookName.wordSpacing(-0.6)
        publisherLabel.attributedText = diary.sentence.publisher.wordSpacing(-0.6)
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
