//
//  HomeDayNightView.swift
//  MoMo
//
//  Created by 초이 on 2021/01/08.
//

import UIKit

class HomeDayNightView: UIView {
    
    // TODO: - noDiaryStackView, filledDiaryView y축 autolayout은 나중에 오브제 나오면 오브제 중 구름에 맞춰야 함

    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var backgroundView: UIView!
    
    // empty view
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noDiaryStackView: UIStackView!
    @IBOutlet weak var writeButton: UIButton!
    
    // filled view
    @IBOutlet weak var emotionImageView: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var diaryLabel: UILabel!
    @IBOutlet weak var filledDiaryView: UIView!
    @IBOutlet weak var showAllButton: UIButton!
    
    // MARK: - Properties
    
    var gradientLayer: CAGradientLayer!
    var date: String?
    
    // MARK: - Functions
    
    // gradient 생성 후 배경 지정
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.backgroundView.bounds
        gradientLayer.colors = [UIColor.HomeDay1.cgColor, UIColor.HomeDay2.cgColor]
        self.backgroundView.layer.addSublayer(gradientLayer)
    }
    
    func getCurrentFormattedDate() -> String? {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy. MM. dd. EEEE"
        dateFormatter.locale = Locale.current
        
        let formattedDate = dateFormatter.string(from: date)
        var dateArray = formattedDate.components(separatedBy: ". ")
        let weekday = dateArray.popLast()
        
        dateArray.append(weekdayEnglishToKorean(weekday: weekday ?? "Monday"))
        
        let formattedDateWithKorean = dateArray.joined(separator: ". ")
        
        let result = "\(dateArray[0])년 \n\(dateArray[1])월 \(dateArray[2])일 \(dateArray[3])"
        return result
    }
    
    func weekdayEnglishToKorean(weekday: String) -> String {
        switch weekday {
        case "Monday":
            return "월요일"
        case "Tuesday":
            return "화요일"
        case "Wednesday":
            return "수요일"
        case "Thursday":
            return "목요일"
        case "Friday":
            return "금요일"
        case "Saturday":
            return "토요일"
        case "Sunday":
            return "일요일"
        default:
            return "월요일"
        }
    }
  
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // gradient 배경 지정
        DispatchQueue.main.async {
            self.createGradientLayer()
        }
    
        // 자간, 행간 지정
        dateLabel.attributedText = dateLabel.text?.textSpacing(lineSpacing: 7)
        emotionLabel.attributedText = emotionLabel.text?.textSpacing(lineSpacing: 10)
        depthLabel.attributedText = depthLabel.text?.textSpacing(lineSpacing: 10)
        quoteLabel.attributedText = quoteLabel.text?.textSpacing(lineSpacing: 10)
        writerLabel.attributedText = writerLabel.text?.textSpacing(lineSpacing: 10)
        bookTitleLabel.attributedText = bookTitleLabel.text?.textSpacing(lineSpacing: 10)
        publisherLabel.attributedText = publisherLabel.text?.textSpacing(lineSpacing: 10)
        diaryLabel.attributedText = diaryLabel.text?.textSpacing(lineSpacing: 10)
        
        // 버튼 rounding 처리
        writeButton.clipsToBounds = true
        writeButton.layer.cornerRadius = 8
        showAllButton.clipsToBounds = true
        showAllButton.layer.cornerRadius = 8
        
        diaryLabel.lineBreakMode = .byTruncatingTail
        
        // 오늘 날짜 받아오기
        date = getCurrentFormattedDate()
        dateLabel.text = date
        
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *),
            let hasUserInterfaceStyleChanged = previousTraitCollection?.hasDifferentColorAppearance(comparedTo: traitCollection),
            hasUserInterfaceStyleChanged {
            // update layer
            createGradientLayer()
        }
    }
}
