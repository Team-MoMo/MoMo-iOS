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
                                 Constants.Design.Image.icDailyBlue!
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
    @IBOutlet weak var touchView: UIView!
    
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
        
        let date = AppDate(serverDate: diary.wroteAt)
        let appEmotion = AppEmotion(rawValue: diary.emotionID)
        let appDepth = AppDepth(rawValue: diary.depth)
        
        iconImage.image = appEmotion?.toBlueIcon()
        categoryLabel.attributedText = appEmotion?.toString().textSpacing()
        let month = String(format: "%02d", date.getMonth())
        let day = String(format: "%02d", date.getDay())
        dateLabel.attributedText = (month+"."+day).textSpacing()
        dayLabel.attributedText = "\(date.getWeekday().toSimpleKorean())".textSpacing()
        
        depthLabel.attributedText = appDepth?.toString().textSpacing()
        
        authorLabel.attributedText = diary.sentence.writer.textSpacing()
        titleLabel.attributedText = "<\(diary.sentence.bookName)>".textSpacing()
        publisherLabel.attributedText = "(\(diary.sentence.publisher))".textSpacing()
    }
    
    // 문구 텍스트 작업
    func customQuote(_ text: String) {
        quoteLabel.attributedText = text.textSpacing()
    }
    
    // 일기 분리 작업
    func divideJournal(_ text: String, _ size: CGFloat) {
        let modifiedText = text.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\n", with: " ")

        guard let font =  UIFont(name: "AppleSDGothicNeo-Regular", size: 12) else {
            return
        }
        
        let labelSize: CGSize = modifiedText.size(withAttributes: [.font: font])
        var length: CGFloat = 0
        var addedString: String = ""
        
        if labelSize.width > size {
            for index in modifiedText.indices {
                let charWidth = String(modifiedText[index]).size(withAttributes: [.font: font]).width
                if length + charWidth > size {
                    self.journalLabel1.attributedText = addedString.textSpacing()
                    self.journalLabel2.attributedText = String(modifiedText[index...]).wordTextSpacing(textSpacing: -0.6, lineSpacing: 4, center: false, truncated: true)
                    break
                }
                length += charWidth
                addedString += String(modifiedText[index])
            }
        } else {
            journalLabel1.attributedText = modifiedText.textSpacing()
        }
    }
    
    // 일기 라벨에 밑줄 처리
    func createLabelUnderline(_ secondJournalLabelSize: CGFloat) {
        DispatchQueue.main.async {
            guard let firstString = self.journalLabel1.text, let secondString = self.journalLabel2.text, let font =  UIFont(name: "AppleSDGothicNeo-Regular", size: 12) else {
                return
            }
            let firstLabelSize: CGSize = firstString.size(withAttributes: [.font: font])
            let secondLabelSize: CGSize = secondString.size(withAttributes: [.font: font])

            let topBorder = CALayer()
            let bottomBorder = CALayer()
            
            topBorder.frame = CGRect(x: 0, y: Int(self.journalLabel1.frame.height) - 1, width: Int(firstLabelSize.width), height: 1)
            topBorder.backgroundColor = UIColor.LineLightGray.cgColor
            
            if secondLabelSize.width < secondJournalLabelSize {
                bottomBorder.frame = CGRect(x: 0, y: self.journalLabel2.frame.height - 1, width: secondLabelSize.width, height: 1)
            } else {
                bottomBorder.frame = CGRect(x: 0, y: self.journalLabel2.frame.height - 1, width: secondJournalLabelSize, height: 1)
            }
            bottomBorder.backgroundColor = UIColor.LineLightGray.cgColor

            self.journalLabel1.layer.addSublayer(topBorder)
            self.journalLabel2.layer.addSublayer(bottomBorder)
        }
    }
}
