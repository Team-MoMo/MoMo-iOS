//
//  ListFilterModalViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/05.
//

import UIKit

// MARK: - Protocols

protocol ListFilterModalViewDelegate: class {
    func sendData(year: Int, month: Int, emotion: Int?, depth: Int?, filterArray: [String], filteredStatus: Bool)
}

class ListFilterModalViewController: UIViewController {
    
    // MARK: - Constants
    
    let zeplinWidth: CGFloat = 375
    let zeplinHeight: CGFloat = 812
    
    let currentDate = AppDate()
    
    let appEmotionArray: [AppEmotion] = [AppEmotion.love,
                                         AppEmotion.happy,
                                         AppEmotion.console,
                                         AppEmotion.angry,
                                         AppEmotion.sad,
                                         AppEmotion.bored,
                                         AppEmotion.memory,
                                         AppEmotion.daily]
    
    let appDepthArray: [AppDepth] = [AppDepth.depth2m,
                                     AppDepth.depth30m,
                                     AppDepth.depth100m,
                                     AppDepth.depth300m,
                                     AppDepth.depth700m,
                                     AppDepth.depth1005m,
                                     AppDepth.depthSimhae]
    
    // MARK: - Properties
    
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    var verify: Bool = false
    var emotion: Int?
    var depth: Int?
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    var year: [String] = []
    var month: [String] = []
    var currentYearMonth: [String] = []
   
    var selectedYear: Int = 0
    var selectedMonth: Int = 0
    var dateText: String = ""
    
    weak var listFilterModalDelegate: ListFilterModalViewDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet var superView: UIView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateViewTop: NSLayoutConstraint!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var emotionView: UIView!
    @IBOutlet weak var emotionLabelTop: NSLayoutConstraint!
    @IBOutlet weak var emotionLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var depthView: UIView!
    @IBOutlet weak var depthLabelTop: NSLayoutConstraint!
    @IBOutlet weak var depthLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var emotionCollectionView: UICollectionView!
    @IBOutlet weak var emotionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var depthViewHeight: NSLayoutConstraint!
    @IBOutlet weak var depthCollectionView: UICollectionView!
    @IBOutlet weak var depthCollectionViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var depthCollectionViewBottom: NSLayoutConstraint!
    @IBOutlet weak var datePickerStackView: UIStackView!
    @IBOutlet weak var yearPickerView: UIPickerView!
    @IBOutlet weak var monthPickerView: UIPickerView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var datePickerStackViewLeading: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        registerXib()
        initailizeConstraint()
        assignDelegate()
        assignDatasource()
        initializeButton()
        initializeLayer(Int(self.height * (233/zeplinHeight)-1))
        initializeLayer(0)
        self.initializeDateData()
        self.datePickerStackView.isHidden = true
        initializePickerView()
        updateDate()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        initializeEmotionDepthProperties()
        DispatchQueue.main.async {
            self.yearPickerView.subviews[1].backgroundColor = UIColor.clear
            self.monthPickerView.subviews[1].backgroundColor = UIColor.clear
        }
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    // MARK: - Private Functions
    
//    private func initializeEmotionDepthProperties() {
//        self.emotion = nil
//        self.depth = nil
//    }
    
    private func initializePickerView() {
        self.yearPickerView.selectRow(selectedYear - 2000, inComponent: 0, animated: true)
        self.monthPickerView.selectRow(selectedMonth-1, inComponent: 0, animated: true)
    }
    
    private func initializeLayer(_ ySize: Int) {
        let layer = CALayer()
        layer.frame = CGRect(x: 0,
                             y: ySize,
                             width: Int(width * 335/zeplinWidth),
                             height: 1)
        layer.backgroundColor = UIColor.LineLightGray.cgColor
        emotionView.layer.addSublayer(layer)
    }

    private func registerXib() {
        emotionCollectionView.register(UINib(nibName: "EmotionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EmotionCollectionViewCell")
        depthCollectionView.register(UINib(nibName: "DepthCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DepthCollectionViewCell")
    }
    
    private func initailizeConstraint() {
        dateViewTop.constant = height * (39/zeplinHeight)
        emotionLabelTop.constant = height * (20/zeplinHeight)
        emotionLabelBottom.constant = height * (16/zeplinHeight)
        emotionViewHeight.constant =  height * (233/zeplinHeight)
        depthViewHeight.constant = height * (154/zeplinHeight)
        depthCollectionViewBottom.constant = height * (23/zeplinHeight)
        depthLabelTop.constant = height * (20/zeplinHeight)
        depthLabelBottom.constant = height * (16/zeplinHeight)
        depthCollectionViewTrailing.constant = width * (21/zeplinHeight)
    }
    
    private func updateDate() {
        dateText = "\(selectedYear)년 \(selectedMonth)월"
        dateLabel.text = dateText
    }
    
    private func assignDelegate() {
        emotionCollectionView.delegate = self
        depthCollectionView.delegate = self
        monthPickerView.delegate = self
        yearPickerView.delegate = self
    }
    
    private func assignDatasource() {
        yearPickerView.dataSource = self
        monthPickerView.dataSource = self
        depthCollectionView.dataSource = self
        emotionCollectionView.dataSource = self
    }
    
    private func initializeButton() {
        applyButton.contentEdgeInsets = UIEdgeInsets(top: height * (8/589), left: width * (76/zeplinWidth), bottom: height * (8/589), right: width * (76/zeplinWidth))
        applyButton.layer.cornerRadius = 20
        applyButton.setTitleColor(UIColor.white, for: .normal)
        applyButton.backgroundColor = .BlueModalAble
    }
    
    private func initializeDateData() {
        for num in 2000...currentDate.getYear() {
            year.append(String(num))
        }
        for num in 1...12 {
            if num <= currentDate.getMonth() {
                currentYearMonth.append(String(num))
            }
            month.append(String(num))
        }
    }
    
    private func updateMonthPickerData(_ selected: String) {
        guard let unwrappedYear = Int(selected) else {
            return
        }
        if selected == currentDate.getYearToString() && selectedYear != currentDate.getYear() {
            self.selectedYear = unwrappedYear
            self.monthPickerView.reloadComponent(0)
        } else if selected != currentDate.getYearToString() && selectedYear == currentDate.getYear() {
            self.selectedYear = unwrappedYear
            self.monthPickerView.reloadComponent(0)
        } else {
            self.selectedYear = unwrappedYear
        }
    }
    
    // dismiss할 때 초기화를 위해 만든 함수
    private func initializeModal() {
        if verify == true {
            self.moreButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 100.0)
            datePickerStackView.isHidden = true
            verify = false
        }
    }
    
    private func dismissToListViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - objc Functions
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        guard translation.y >= 0 else {
            return
        }
        
        guard let origin = pointOrigin else {
            return
        }
        
        view.frame.origin = CGPoint(x: 0, y: origin.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1330 {
                initializeModal()
                dismissToListViewController()
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = origin
                }
            }
        }
    }

    // MARK: - IBActions
    
    @IBAction func touchMoreButton(_ sender: Any) {
        if !verify {
            self.view.frame = CGRect(origin:
                                        CGPoint(x: 0,
                                                y: self.height*0.08),
                                     size: CGSize(width: self.width,
                                                  height: self.height * 0.92))
            UIView.animate(withDuration: 0.5) {
                self.dateView.layoutIfNeeded()
                self.moreButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
            }
            pointOrigin = self.view.frame.origin
            datePickerStackView.isHidden = false
            verify.toggle()
        } else {
            self.view.frame = CGRect(origin: CGPoint(x: 0,
                                                     y: self.height*0.27),
                                     size: CGSize(width: self.width,
                                                  height: self.height * 0.73))
            UIView.animate(withDuration: 0.5) {
                self.dateView.layoutIfNeeded()
                self.moreButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 100.0)
            }
            pointOrigin = self.view.frame.origin
            datePickerStackView.isHidden = true
            verify.toggle()
        }
    }
    
    @IBAction func touchCloseButton(_ sender: Any) {
        initializeModal()
        dismissToListViewController()
    }
    
    @IBAction func touchApplyButton(_ sender: Any) {
        var tempFilterArray: [String] = []
        var tempEmotionId: Int?
        var tempDepthId: Int?
        if let unwrappedEmotion = emotion {
            tempFilterArray.append(appEmotionArray[unwrappedEmotion].toString())
            tempEmotionId = appEmotionArray[unwrappedEmotion].rawValue
        }

        if let unwrappedDepth = depth {
            tempFilterArray.append(appDepthArray[unwrappedDepth].toString())
            tempDepthId = appDepthArray[unwrappedDepth].rawValue
        }
        
        listFilterModalDelegate?.sendData(year: selectedYear,
                                        month: selectedMonth,
                                        emotion: tempEmotionId,
                                        depth: tempDepthId,
                                        filterArray: tempFilterArray,
                                        filteredStatus: true)
        initializeModal()
        dismissToListViewController()
    }
}

// MARK: - UICollectionViewDataSource

extension ListFilterModalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.emotionCollectionView {
            return appEmotionArray.count
        } else {
            return appDepthArray.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.emotionCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmotionCollectionViewCell", for: indexPath) as? EmotionCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.updateImage(appEmotionArray[indexPath.row].toUnselectedIcon())
            cell.emotion = appEmotionArray[indexPath.row]
            if let unwrappedEmotion = emotion {
                if indexPath.row == unwrappedEmotion {
                    cell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
                }
            }
            cell.tag = appEmotionArray[indexPath.row].rawValue
        
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DepthCollectionViewCell", for: indexPath) as? DepthCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.initializeLabel(appDepthArray[indexPath.row].toString())
        cell.backView.layer.borderColor = UIColor.Black6.cgColor
        cell.backView.layer.borderWidth = 1
        cell.backView.layer.cornerRadius = cell.layer.frame.height * 0.5
        
        if let unwrappedDepth = depth {
            if indexPath.row == unwrappedDepth {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
            }
        }
        
        cell.tag = indexPath.row
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ListFilterModalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.emotionCollectionView {
            // 늘어나는 너비와 높이에 맞게 만들기 위해 가중치를 둬서 구함
            return CGSize(width: (width*(20/zeplinWidth)) + (height*(50/zeplinHeight)), height: (width*(20/zeplinWidth)) + (height*(50/zeplinHeight)))
        }
        
        let stringWidth = appDepthArray[indexPath.row].toString().size(withAttributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold)])
        return CGSize(width: stringWidth.width + pow(width * 6 / zeplinWidth, 2), height: height * (33/zeplinHeight))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == self.emotionCollectionView {
            return height * (8/zeplinWidth)
        }
        return height * (4/zeplinWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == self.emotionCollectionView {
            return width * (7.5/zeplinWidth)
        }
        return width * (5/zeplinWidth)
    }
    
    // 셀 하나를 선택했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.emotionCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmotionCollectionViewCell else {
                return
            }
            if emotion == indexPath.row {
                emotion = nil
                collectionView.deselectItem(at: indexPath, animated: true)
                cell.isSelected = false
            } else {
                emotion = indexPath.row
            }
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? DepthCollectionViewCell else {
                return
            }
            if depth == indexPath.row {
                depth = nil
                collectionView.deselectItem(at: indexPath, animated: true)
                cell.isSelected = false
            } else {
                depth = indexPath.row
            }
        }
    }
    
    // 선택이 해제 됐을 때
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if collectionView == self.emotionCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmotionCollectionViewCell else {
                return
            }
            cell.updateImage(appEmotionArray[indexPath.row].toUnselectedIcon())
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? DepthCollectionViewCell else {
                return
            }
            cell.backView.layer.borderColor = UIColor.Black6.cgColor
            cell.depthLabel.textColor = UIColor.Black6
            cell.backView.backgroundColor = UIColor.white
        }
    }
}

// MARK: - UIPickerViewDelegate

extension ListFilterModalViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return self.view.frame.height * 40/zeplinHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.view.frame.width * 70/zeplinWidth
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == self.yearPickerView {
            return NSAttributedString(string: year[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        } else if selectedYear == currentDate.getYear() {
            return NSAttributedString(string: currentYearMonth[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        }
        return NSAttributedString(string: month[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.yearPickerView {
            updateMonthPickerData(self.year[row])
        } else if selectedYear == currentDate.getYear() {
            guard let month = Int(currentYearMonth[row]) else {
                return
            }
            selectedMonth = month
        } else {
            guard let month = Int(month[row]) else {
                return
            }
            selectedMonth = month
        }
        updateDate()
    }
}

// MARK: - UIPickerViewDataSource

extension ListFilterModalViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.yearPickerView {
            return year.count
        } else if selectedYear == currentDate.getYear() {
            if selectedMonth > currentDate.getMonth() {
                selectedMonth = currentDate.getMonth()
            }
            return currentYearMonth.count
        } else {
            return month.count
        }
    }
}
