//
//  ListFilterModalViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/05.
//

import UIKit

protocol ModalPassDataDelegate: class {
    func sendData(num: Int, text: String)
}

class ListFilterModalViewController: UIViewController {
    
    // MARK: - Properties
    
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    var verify: Bool = false
    var emotion: Int? = nil
    var depth: Int? = nil
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    var year: [String] = []
    var month: [String] = []
    var selectedYear: String = ""
    var selectedMonth: String = ""
    
    var modalPassDataDelegate : ModalPassDataDelegate?
    
    
    let emotionArray: [String] = ["iosFilterLoveUnselected",
                                  "iosFilterHappyUnselected",
                                  "iosFilterConsoleUnselected",
                                  "iosFilterAngryUnselected",
                                  "iosFilterSadUnselected",
                                  "iosFilterBoredUnselected",
                                  "iosFilterMemoryUnselected",
                                  "iosFilterDailyUnselected"
    ]
    
    let selectedEmotionArray: [String] = ["iosFilterLoveSelected",
                                          "iosFilterHappySelected",
                                          "iosFilterConsoleSelected",
                                          "iosFilterAngrySelected",
                                          "iosFilterSadSelected",
                                          "iosFilterBoredSelected",
                                          "iosFilterMemorySelected",
                                          "iosFilterDailySelected"
     ]
    
    let depthArray: [String] = ["2m", "30m", "100m", "300m", "700m", "1005m", "심해"]
    
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
    @IBOutlet weak var datePickerStackViewTrailing: NSLayoutConstraint!
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        registerXib()
        setConstraint()
        setDelegate()
        setDatasource()
        setButton()
        setLayer(Int(height * (233/812)-1))
        setLayer(0)
        self.addData()
        self.datePickerStackView.isHidden = true
    }
    
    func setLayer(_ ySize: Int) {
        let layer = CALayer()
        layer.frame = CGRect(x: 0,
                             y: ySize,
                             width: Int(width * 335/375),
                             height: 1)
        emotionView.layer.addSublayer(layer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

    // MARK: - Method
    
    private func registerXib() {
        emotionCollectionView.register(UINib(nibName: "EmotionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EmotionCollectionViewCell")
        depthCollectionView.register(UINib(nibName: "DepthCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DepthCollectionViewCell")
    }
    
    private func setConstraint() {
        dateViewTop.constant = height * (39/812)
        emotionLabelTop.constant = height * (20/812)
        emotionLabelBottom.constant = height * (16/812)
        emotionViewHeight.constant =  height * (233/812)
        depthViewHeight.constant = height * (154/812)
        depthCollectionViewBottom.constant = height * (23/812)
        depthLabelTop.constant = height * (20/812)
        depthLabelBottom.constant = height * (16/812)
        depthCollectionViewTrailing.constant = width * (21/375)
    }
    
    private func setDelegate() {
        emotionCollectionView.delegate = self
        depthCollectionView.delegate = self
        monthPickerView.delegate = self
        yearPickerView.delegate = self
    }
    
    private func setDatasource() {
        yearPickerView.dataSource = self
        monthPickerView.dataSource = self
        depthCollectionView.dataSource = self
        emotionCollectionView.dataSource = self
    }
    
    private func setButton() {
        applyButton.contentEdgeInsets = UIEdgeInsets(top: height * (8/589), left: width * (76/375), bottom: height * (8/589), right: width * (76/375))
        applyButton.layer.cornerRadius = 20
        applyButton.setTitleColor(UIColor.white, for: .normal)
        applyButton.backgroundColor = .BlueModalAble
    }
    
    func addData() {
        for num in 2020...3000 {
            year.append(String(num))
        }
        for num in 1...12 {
            month.append(String(num))
        }
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        guard translation.y >= 0 else {
            return
        }
        
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1330 {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin!
                }
            }
        }
    }

    // MARK: - IBAction
    
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchApplyButton(_ sender: Any) {
//        self.shitDelegate?.sendData(num: 1000, text: "cba")
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension ListFilterModalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.emotionCollectionView {
            return emotionArray.count
        } else {
            return depthArray.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.emotionCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmotionCollectionViewCell", for: indexPath) as? EmotionCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.setImage(emotionArray[indexPath.row])
            cell.tag = indexPath.row
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DepthCollectionViewCell", for: indexPath) as? DepthCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setLabel(depthArray[indexPath.row])
        cell.backView.layer.borderColor = UIColor.Black6.cgColor
        cell.backView.layer.borderWidth = 1
        cell.backView.layer.cornerRadius = cell.layer.frame.height * 0.5
        cell.tag = indexPath.row
        return cell
    }
}

extension ListFilterModalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.emotionCollectionView {
            // 늘어나는 너비와 높이에 맞게 만들기 위해 가중치를 둬서 구함
            return CGSize(width: (width*(20/375)) + (height*(50/812)), height: (width*(20/375)) + (height*(50/812)))
        }
        
        let stringWidth = depthArray[indexPath.row].size(withAttributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold)])
        return CGSize(width: stringWidth.width + pow(width * 6 / 375, 2), height: height * (33/812))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == self.emotionCollectionView {
            return height * (8/375)
        }
        return height * (4/375)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == self.emotionCollectionView {
            return width * (7.5/375)
        }
        return width * (5/375)
    }
    
    // 셀 하나를 선택했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.emotionCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmotionCollectionViewCell else {
                return
            }
            if emotion == indexPath.row {
                cell.setImage(emotionArray[indexPath.row])
                emotion = nil
            } else {
                cell.setImage(selectedEmotionArray[indexPath.row])
                emotion = indexPath.row
            }
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? DepthCollectionViewCell else {
                return
            }
            if depth == indexPath.row {
                cell.backView.layer.borderColor = UIColor.Black6.cgColor
                cell.depthLabel.textColor = UIColor.Black6
                cell.backView.backgroundColor = UIColor.white
                depth = nil
            } else {
                cell.backView.layer.borderColor = UIColor.Blue2.cgColor
                cell.depthLabel.textColor = UIColor.Blue2
                cell.backView.backgroundColor = UIColor.Blue6
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
            cell.setImage(emotionArray[indexPath.row])
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

extension ListFilterModalViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return self.view.frame.height * 40/812
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.view.frame.width * 70/375
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.yearPickerView {
            return year[row]
        }
        return month[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.yearPickerView {
            selectedYear = year[row]
            return
        }
        selectedMonth = month[row]
        return
    }
}

extension ListFilterModalViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.yearPickerView {
            return year.count
        }
        return month.count
    }
}
