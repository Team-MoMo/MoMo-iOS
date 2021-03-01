//
//  HomeDayNightView.swift
//  MoMo
//
//  Created by 초이 on 2021/01/08.
//

import UIKit

protocol HomeDayNightViewDelegate: class {
    func writeButtonTouchUp(_ sender: UIButton)
    func showAllButtonTouchUp(_ sender: UIButton, diaryId: Int)
}

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
    
    weak var homeDayNightViewDelegate: HomeDayNightViewDelegate?
    var gradientLayer: CAGradientLayer!
    var date: String?
    // year, month, day
    var dateArray: [String] = ["", "", ""]
    var todayDiary: [Diary] = []
    
    var diaryId: Int = 1
    
    var moodArray = ["", "love", "happy", "console", "angry", "sad", "bored", "memory", "daily"]
    var depthArray = ["2m", "30m", "100m", "300m", "700m", "1,005m", "심해"]
    
    // MARK: - Functions
    
    // gradient 생성 후 배경 지정
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.backgroundView.bounds
        gradientLayer.colors = [UIColor.HomeDay1.cgColor, UIColor.HomeDay2.cgColor]
        self.backgroundView.layer.addSublayer(gradientLayer)
    }
    
    func getCurrentFormattedDate() -> String? {
        
        let today = AppDate()
        let year = today.getYearToString()
        let month = today.getMonthToString()
        let day = today.getDayToString()
        let weekDay = today.getWeekday().toKorean()
        
        dateArray[0] = year
        dateArray[1] = month
        dateArray[2] = day
        
        let result = "\(year)년 \n\(month)월 \(day)일 \(weekDay)"
        
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
        
        // 오늘 쓴 일기 있는지 통신
        self.getSeletectedDateDiaryAPI()
        
        // 맨 처음에 모든 뷰 가리기
        filledDiaryView.isHidden = true
        showAllButton.isHidden = true
        noDiaryStackView.isHidden = true
        writeButton.isHidden = true
    }
    
    // MARK: - Functions
    
    // empty view 보이게
    func showEmptyView() {
        noDiaryStackView.isHidden = false
        writeButton.isHidden = false
        
        filledDiaryView.isHidden = true
        showAllButton.isHidden = true
    }
    
    // filled view 보이게
    func showFilledView() {
        noDiaryStackView.isHidden = true
        writeButton.isHidden = true
        
        filledDiaryView.isHidden = false
        showAllButton.isHidden = false
    }
    
    @IBAction func writeButtonTouchUp(_ sender: UIButton) {
        self.homeDayNightViewDelegate?.writeButtonTouchUp(self.writeButton)
    }
    
    @IBAction func showAllButtonTouchUp(_ sender: UIButton) {
        self.homeDayNightViewDelegate?.showAllButtonTouchUp(self.showAllButton, diaryId: diaryId)
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

extension HomeDayNightView {
    func getSeletectedDateDiaryAPI() {
        
        let userId = UserDefaults.standard.integer(forKey: "userId")
        
        DiariesService.shared.getDiaries(userId: "\(userId)",
                                         year: dateArray[0],
                                         month: dateArray[1],
                                         order: "filter",
                                         day: Int(dateArray[2]),
                                         emotionId: nil,
                                         depth: nil
        ) { (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let diary = data as? [Diary] {
                    self.todayDiary = diary
                    //print(self.todayDiary[0])
                    let length = self.todayDiary.count
                    if self.todayDiary.count >= 1 {
                        self.showFilledView()
                        let moodEnumCase = self.todayDiary[length-1].emotionID
                        self.emotionImageView.image = AppEmotion(rawValue: moodEnumCase)?.toBlueIcon()
                        self.emotionLabel.text = AppEmotion(rawValue: moodEnumCase)?.toString()
                        self.depthLabel.text = AppDepth(rawValue: self.todayDiary[length-1].depth)?.toString()
                        self.quoteLabel.text = self.todayDiary[length-1].sentence.contents
                        self.writerLabel.text = self.todayDiary[length-1].sentence.writer
                        self.bookTitleLabel.text = self.todayDiary[length-1].sentence.bookName
                        self.publisherLabel.text = self.todayDiary[length-1].sentence.publisher
                        self.diaryLabel.text = self.todayDiary[length-1].contents
                        
                        self.diaryId = self.todayDiary[length-1].id
                    } else {
                        self.showEmptyView()
                    }

                    print("success at getSeletectedDateDiaryAPI")
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr at getSeletectedDateDiaryAPI")
            case .serverErr:
                print("serverErr at getSeletectedDateDiaryAPI")
            case .networkFail:
                print("networkFail at getSeletectedDateDiaryAPI")
            }
        }
    }
}
