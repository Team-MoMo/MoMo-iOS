//
//  HomeModalViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/15.
//

import UIKit

protocol StatModalViewDelegate: class {
    func passData(year: Int, month: Int)
}


class HomeModalViewController: UIViewController {

    @IBOutlet weak var yearPickerView: UIPickerView!
    @IBOutlet weak var monthPickerView: UIPickerView!
    
    var year: Int = 0
    var month: Int = 0

    var yearArray: [String] = []
    var monthArray: [String] = []
    
    weak var statModalViewDelegate: StatModalViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        assignDelegate()
        assignDatasource()
        setPickerInitialSetting()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.yearPickerView.subviews[1].backgroundColor = UIColor.clear
            self.monthPickerView.subviews[1].backgroundColor = UIColor.clear
        }
    }
    
    private func assignDatasource() {
        self.monthPickerView.dataSource = self
        self.yearPickerView.dataSource = self
    }
    
    private func assignDelegate() {
        self.monthPickerView.delegate = self
        self.yearPickerView.delegate = self
    }

    private func setData() {
        for tempYear in 2000...2021 {
            yearArray.append(String(tempYear))
        }
        for tempMonth in 1...12 {
            monthArray.append(String(tempMonth))
        }
    }
    
    private func setPickerInitialSetting() {
        self.yearPickerView.selectRow(self.year - 2000, inComponent: 0, animated: true)
        self.monthPickerView.selectRow(self.month - 1, inComponent: 0, animated: true)
    }
    
    
    @IBAction func touchCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  
    @IBAction func touchApplyButton(_ sender: Any) {
        guard let modal = statModalViewDelegate else {
            return
        }
        modal.passData(year: self.year, month: self.month)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension HomeModalViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.yearPickerView {
            return yearArray[row]
        } else {
            return monthArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == self.yearPickerView {
            return NSAttributedString(string: yearArray[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        } else {
            return NSAttributedString(string: monthArray[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.yearPickerView {
            year = Int(yearArray[row]) ?? 0
        } else {
            month = Int(monthArray[row]) ?? 0
        }
    }
}

extension HomeModalViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.yearPickerView {
            return yearArray.count
        } else {
            return monthArray.count
        }
    }
}
