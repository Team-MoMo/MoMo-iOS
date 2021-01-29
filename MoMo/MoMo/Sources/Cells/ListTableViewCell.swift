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
        initializeIBOutlets()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func initializeIBOutlets() {
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
    
    // 리스트테이블뷰셀 데이터 입력 문구와 일기를 제외한 모든 데이터 추가
    func parseDiaryAll(diary: Diary) {
        let date = diary.wroteAt.split(separator: "T")[0]
        let specificDate = date.split(separator: "-")
        let appEmotion = AppEmotion(rawValue: diary.emotionID)
        let appDepth = AppDepth(rawValue: diary.depth)
        
        iconImage.image = appEmotion?.toBlueIcon()
        categoryLabel.attributedText = appEmotion?.toString().wordSpacing(-0.6)
        dateLabel.attributedText = "\(specificDate[0])년 \(specificDate[1])월".wordSpacing(-0.6)
        dayLabel.attributedText = "\(specificDate[2])일".wordSpacing(-0.6)
        
        depthLabel.attributedText = appDepth?.toString().wordSpacing(-0.6)
        
        authorLabel.attributedText = diary.sentence.writer.wordSpacing(-0.6)
        titleLabel.attributedText = "<\(diary.sentence.bookName)>".wordSpacing(-0.6)
        publisherLabel.attributedText = "(\(diary.sentence.publisher))".wordSpacing(-0.6)
        }
    
    // 문구 텍스트 작업
    func customQuote(_ text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.kern, value: -0.6, range: NSRange(location: 0, length: attributedString.length))

        quoteLabel.attributedText = attributedString
    }
    
    // 일기 분리 작업
    func divideJournal(_ text: String, _ size: CGFloat) {
        let labelSize: CGSize = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 13, weight: .regular)])
        var length: CGFloat = 0
        var addedString: String = ""
        if labelSize.width > size {
            DispatchQueue.main.async {
                for index in text.indices {
                    let charWidth = String(text[index]).size(withAttributes: [.font: UIFont.systemFont(ofSize: 13, weight: .regular)]).width
                    if length + charWidth > size {
                        let firstString = NSMutableAttributedString(string: addedString)
                        let secondString = NSMutableAttributedString(string: String(text[index...]))
                        firstString.addAttribute(NSAttributedString.Key.kern, value: -0.6, range: NSRange(location: 0, length: firstString.length))
                        secondString.addAttribute(NSAttributedString.Key.kern, value: -0.6, range: NSRange(location: 0, length: secondString.length))
                        self.journalLabel1.attributedText = firstString
                        self.journalLabel2.attributedText = secondString
                        break
                    }
                    length += charWidth
                    addedString += String(text[index])
                }
            }
        } else {
            journalLabel1.attributedText = text.wordSpacing(-0.6)
        }
    }
    
    // 일기 라벨에 밑줄 처리
    func createLabelUnderline(_ size1: CGFloat, _ size2: CGFloat) {
        DispatchQueue.main.async {
            guard let firstString = self.journalLabel1.text, let secondString = self.journalLabel2.text else {
                return
            }
            let firstLabelSize: CGSize = firstString.size(withAttributes: [.font: UIFont.systemFont(ofSize: 12, weight: .regular)])
            let secondLabelSize: CGSize = secondString.size(withAttributes: [.font: UIFont.systemFont(ofSize: 12, weight: .regular)])

            let topBorder = CALayer()
            let bottomBorder = CALayer()
            
            topBorder.frame = CGRect(x: 0, y: Int(self.journalLabel1.frame.height) - 1, width: Int(firstLabelSize.width), height: 1)
            topBorder.backgroundColor = UIColor.LineLightGray.cgColor
            
            if secondLabelSize.width < size2 {
                bottomBorder.frame = CGRect(x: 0, y: self.journalLabel2.frame.height - 1, width: secondLabelSize.width, height: 1)
            } else {
                bottomBorder.frame = CGRect(x: 0, y: self.journalLabel2.frame.height - 1, width: size2-30, height: 1)
            }
            bottomBorder.backgroundColor = UIColor.LineLightGray.cgColor

            self.journalLabel1.layer.addSublayer(topBorder)
            self.journalLabel2.layer.addSublayer(bottomBorder)
        }
    }
}
