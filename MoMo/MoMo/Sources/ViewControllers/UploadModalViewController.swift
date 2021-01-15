//
//  UploadModalViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/12.
//

import UIKit

protocol UploadModalPassDataDelegate: class {
    func passData(_ date: String)
}

class UploadModalViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var yearPickerView: UIPickerView!
    @IBOutlet weak var monthPickerView: UIPickerView!
    @IBOutlet weak var dayPickerView: UIPickerView!
    @IBOutlet weak var applyButton: UIButton!
    
    var year: Int = 0
    var month: Int = 0
    var day: Int = 0

    var yearArray: [String] = []
    var monthArray: [String] = []
    var dayArray: [[String]] = [
        (1...31).map {String($0)},
        (1...30).map {String($0)},
        (1...29).map {String($0)}
    ]
    var uploadModalDataDelegate: UploadModalPassDataDelegate?
    let weekdayArray = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"]
    var dayIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerDelegate()
        registerDataSource()
        setData()
        calculateToday()
        setPickerInitialSetting()
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        descriptionLabel.attributedText = "날짜 변경".wordSpacing(-0.6)
        applyButton.layer.cornerRadius = 20
        applyButton.backgroundColor = UIColor.BlueModalAble
        print(year)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.yearPickerView.subviews[1].backgroundColor = UIColor.clear
            self.monthPickerView.subviews[1].backgroundColor = UIColor.clear
            self.dayPickerView.subviews[1].backgroundColor = UIColor.clear
        }
    }

    @IBAction func touchCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setPickerInitialSetting() {
        self.yearPickerView.selectRow(self.year - 2000, inComponent: 0, animated: true)
        self.monthPickerView.selectRow(self.month - 1, inComponent: 0, animated: true)
        coordinateDay()
        self.dayPickerView.selectRow(self.day - 1, inComponent: 0, animated: true)
    }
    
    private func setData() {
        for tempYear in 2000...2021 {
            yearArray.append(String(tempYear))
        }
        for tempMonth in 1...12 {
            monthArray.append(String(tempMonth))
        }
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
    
    func calculateToday() {
        let date = Date()
        let dateFormatter = DateFormatter()
            
        dateFormatter.dateFormat = "yyyy. MM. dd. EEEE"
        dateFormatter.locale = Locale.current
        let formattedDate = dateFormatter.string(from: date)
        let formattedDateArray = formattedDate.split(separator: ".")
        year = Int(String(formattedDateArray[0])) ?? 0
        month = Int(String(formattedDateArray[1]).trimmingCharacters(in: .whitespaces)) ?? 0
        day = Int(String(formattedDateArray[2]).trimmingCharacters(in: .whitespaces)) ?? 0
    }
    
    private func coordinateDay() {
        switch self.month {
        case 1, 3, 5, 7, 8, 10, 12:
            if dayIndex != 0 {
                dayIndex = 0
                self.dayPickerView.reloadAllComponents()
            }
        case 2:
            if dayIndex != 2 {
                dayIndex = 2
                self.dayPickerView.reloadAllComponents()
            }
        default:
            if dayIndex != 1 {
                dayIndex = 1
                self.dayPickerView.reloadAllComponents()
            }
        
        }
    }
    
    @IBAction func touchApplyButton(_ sender: Any) {
        let dateComponents = NSDateComponents()
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        
        guard let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian) else {
            return
        }
        let date = gregorianCalendar.date(from: dateComponents as DateComponents)
        let weekday = gregorianCalendar.component(.weekday, from: date!)
        let stringMonth = String(format: "%02d", month)
        self.uploadModalDataDelegate?.passData("\(year). \(stringMonth). \(day). \(weekdayArray[weekday-1])")
        self.presentingViewController?.dismiss(animated: true, completion: nil)

    }
    
}

extension UploadModalViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.yearPickerView {
            return yearArray[row]
        } else if pickerView == self.monthPickerView {
            return monthArray[row]
        } else {
            return dayArray[dayIndex][row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.yearPickerView {
            year = Int(yearArray[row]) ?? 0
        } else if pickerView == self.monthPickerView {
            month = Int(monthArray[row]) ?? 0
            coordinateDay()
        } else {
            day = Int(dayArray[dayIndex][row]) ?? 0
        }
    }
}

extension UploadModalViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.yearPickerView {
            return yearArray.count
        } else if pickerView == self.monthPickerView {
            return monthArray.count
        }
        return dayArray[dayIndex].count
    }
    
}
