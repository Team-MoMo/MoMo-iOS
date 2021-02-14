//
//  UploadModalViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/12.
//

import UIKit

// MARK: - Protocols
 
protocol UploadModalViewDelegate: class {
    func passData(_ date: String)
}

class UploadModalViewController: UIViewController {
    
    // MARK: - Properties
    
    var verifyMood: Bool = true // true이면 무드뷰컨에서 넘어온 것
    
    var year: Int? = 0
    var month: Int? = 0
    var day: Int? = 0

    var yearArray: [String] = []
    var monthArray: [String] = []
    var dayArray: [[String]] = [
        (1...31).map {String($0)},
        (1...30).map {String($0)},
        (1...29).map {String($0)}
    ]
    
    var currentMonthArray: [String] = []
    var currentDayArray: [String] = []
    
    weak var uploadModalDataDelegate: UploadModalViewDelegate?
    
    var dayIndex: Int = 0

    // MARK: - Constants
    
    let currentDate = AppDate()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var yearPickerView: UIPickerView!
    @IBOutlet weak var monthPickerView: UIPickerView!
    @IBOutlet weak var dayPickerView: UIPickerView!
    @IBOutlet weak var applyButton: UIButton!
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerDelegate()
        registerDataSource()
        initializeDateData()
        initializeViewLayer()
        initializeDescriptionLabel()
        initializeApplyButtonAttribute()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.yearPickerView.subviews[1].backgroundColor = UIColor.clear
            self.monthPickerView.subviews[1].backgroundColor = UIColor.clear
            self.dayPickerView.subviews[1].backgroundColor = UIColor.clear
            self.initializePickerViews()
        }
    }
    
    // MARK: - Private Functions
    
    private func initializeApplyButtonAttribute() {
        applyButton.layer.cornerRadius = 20
        applyButton.backgroundColor = UIColor.BlueModalAble
    }
    
    private func initializeDescriptionLabel() {
        descriptionLabel.attributedText = "날짜 변경".wordSpacing(-0.6)
    }
    
    private func initializeViewLayer() {
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func initializePickerViews() {
        guard let unwrappedYear = self.year,
              let unwrappedMonth = self.month,
              let unwrappedDay = self.day else {
            return
        }
        self.yearPickerView.selectRow(unwrappedYear - 2000, inComponent: 0, animated: true)
        self.monthPickerView.selectRow(unwrappedMonth - 1, inComponent: 0, animated: true)
        updateDayData()
        self.dayPickerView.selectRow(unwrappedDay - 1, inComponent: 0, animated: true)
    }
    
    private func initializeDateData() {
        yearArray = (2000...currentDate.getYear()).map({String($0)})
        monthArray = (1...12).map({String($0)})
        currentMonthArray = (1...currentDate.getMonth()).map({String($0)})
        currentDayArray = (1...currentDate.getDay()).map({String($0)})
    }
    
    private func registerDelegate() {
        dayPickerView.delegate = self
        monthPickerView.delegate = self
        yearPickerView.delegate = self
    }
    
    private func registerDataSource() {
        dayPickerView.dataSource = self
        monthPickerView.dataSource = self
        yearPickerView.dataSource = self
    }
    
    private func dismissToMoodViewController() {
        self.dismiss(animated: true, completion: nil)
    }

    private func updateMonthData(_ selectedYear: Int) {
        if self.year != currentDate.getYear() && selectedYear == currentDate.getYear() {
            self.year = selectedYear
            guard let unwrappedMonth = self.month else {
                return
            }
            if unwrappedMonth > self.currentDate.getMonth() {
                self.month = self.currentDate.getMonth()
            }
            self.monthPickerView.reloadComponent(0)
            updateDayData(true)
        } else if self.year == currentDate.getYear() && selectedYear != currentDate.getYear() {
            self.year = selectedYear
            self.monthPickerView.reloadComponent(0)
            updateDayData(true)
        } else {
            self.year = selectedYear
            updateDayData()
        }
    }
    
    private func updateDayData(_ currentYearSelected: Bool = false) {
        switch self.month {
        case 1, 3, 5, 7, 8, 10, 12:
            if dayIndex != 0 || currentYearSelected {
                dayIndex = 0
                self.dayPickerView.reloadComponent(0)
            }
            
        case 2:
            if dayIndex != 2 || currentYearSelected {
                dayIndex = 2
                self.dayPickerView.reloadComponent(0)
            }
            
        default:
            if dayIndex != 1 ||  currentYearSelected {
                dayIndex = 1
                self.dayPickerView.reloadComponent(0)
            }
        }
    }
    
    private func getDiariesWithAPI(userID: String,
                       year: String,
                       month: String,
                       order: String,
                       day: Int?,
                       emotionID: Int?,
                       depth: Int?) {
        DiariesService.shared.getDiaries(userId: userID,
                                         year: year,
                                         month: month,
                                         order: order,
                                         day: day,
                                         emotionId: emotionID,
                                         depth: depth) {
            (networkResult) -> () in
            switch networkResult {

            case .success(let data):
                if let diary = data as? [Diary] {
                    if diary.count > 0 {
                        self.applyButton.isEnabled = false
                        self.applyButton.backgroundColor = UIColor.Black6
                    } else {
                        self.applyButton.isEnabled = true
                        self.applyButton.backgroundColor = UIColor.BlueModalAble

                    }
                }
                
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func touchCloseButton(_ sender: Any) {
        dismissToMoodViewController()
    }
    
    @IBAction func touchApplyButton(_ sender: Any) {
        guard let unwrappedYear = self.year,
              let unwrappedMonth = self.month,
              let unwrappedDay = self.day else {
            return
        }
        let selectedDate = AppDate(year: unwrappedYear,
                                   month: unwrappedMonth,
                                   day: unwrappedDay)
        let stringMonth = String(format: "%02d", selectedDate.getMonth())
        let stringDay = String(format: "%02d", selectedDate.getDay())
        self.uploadModalDataDelegate?.passData("\(selectedDate.getYear()). \(stringMonth). \(stringDay). \(selectedDate.getWeekday().toKorean())")
        dismissToMoodViewController()
    }
}

// MARK: - UIPickerViewDelegate

extension UploadModalViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == self.yearPickerView {
            return NSAttributedString(string: yearArray[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        } else if pickerView == self.monthPickerView {
            return NSAttributedString(string: monthArray[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        } else {
            return NSAttributedString(string: dayArray[dayIndex][row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.yearPickerView {
            guard let unwrappedYear = Int(yearArray[row]) else {
                return
            }
            updateMonthData(unwrappedYear)
        } else if pickerView == self.monthPickerView {
            guard let unwrappedMonth = Int(monthArray[row]) else {
                return
            }
            month = unwrappedMonth
            updateDayData()
        } else {
            guard let unwrappedDay = Int(dayArray[dayIndex][row]) else {
                return
            }
            day = unwrappedDay
        }
        if verifyMood {
            guard let unwrappedYear = self.year,
                  let unwrappedMonth = self.month,
                  let unwrappedDay = self.day else {
                return
            }
            getDiariesWithAPI(userID: String(APIConstants.userId),
                          year: "\(unwrappedYear)",
                          month: "\(unwrappedMonth)",
                          order: "filter",
                          day: unwrappedDay,
                          emotionID: nil,
                          depth: nil)
        }
    }
}

// MARK: - UIPickerViewDataSource

extension UploadModalViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.yearPickerView {
            return yearArray.count
        } else if pickerView == self.monthPickerView {
            if year == currentDate.getYear() {
                return currentMonthArray.count
            }
            return monthArray.count
        } else if year == currentDate.getYear() && month == currentDate.getMonth() {
            guard let unwrappedDay = self.day else {
                return Int()
            }
            if unwrappedDay > currentDate.getDay() {
                self.day = currentDate.getDay()
            }
            return currentDayArray.count
        }
        return dayArray[dayIndex].count
    }
    
}
