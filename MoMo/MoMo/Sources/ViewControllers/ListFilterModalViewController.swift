//
//  ListFilterModalViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/05.
//

import UIKit

class ListFilterModalViewController: UIViewController {
    
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    var verify: Bool = false
    var emotion: Int? = nil
    var depth: Int? = nil
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    var year: [String] = []
    var month: [String] = []
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        dateViewTop.constant = height * (39/812)
        emotionLabelTop.constant = height * (20/812)
        emotionLabelBottom.constant = height * (16/812)
        emotionViewHeight.constant =  height * (233/812)
        depthViewHeight.constant = height * (154/812)
        applyButton.contentEdgeInsets = UIEdgeInsets(top: height * (8/589), left: width * (76/375), bottom: height * (8/589), right: width * (76/375))
        depthCollectionViewBottom.constant = height * (23/812)
        depthLabelTop.constant = height * (20/812)
        depthLabelBottom.constant = height * (16/812)
        emotionCollectionView.register(UINib(nibName: "EmotionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EmotionCollectionViewCell")
        emotionCollectionView.dataSource = self
        emotionCollectionView.delegate = self
        depthCollectionViewTrailing.constant = width * (21/375)
        depthCollectionView.register(UINib(nibName: "DepthCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DepthCollectionViewCell")
        depthCollectionView.dataSource = self
        depthCollectionView.delegate = self
        applyButton.isEnabled = false
        applyButton.layer.cornerRadius = applyButton.frame.height*0.7
        applyButton.backgroundColor = .Black6
        applyButton.setTitleColor(UIColor.white, for: .disabled)
        applyButton.setTitleColor(UIColor.white, for: .normal)
        let bottomLayer = CALayer()
        let topLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: 0, width: Int(width * 335/375), height: 1)
        bottomLayer.backgroundColor = UIColor.LineLightGray.cgColor
        topLayer.frame = CGRect(x: 0, y: Int(height * (233/812)-1), width: Int(width * 335/375), height: 1)
        topLayer.backgroundColor = UIColor.LineLightGray.cgColor
        emotionView.layer.addSublayer(bottomLayer)
        emotionView.layer.addSublayer(topLayer)
        yearPickerView.delegate = self
        yearPickerView.dataSource = self
        monthPickerView.delegate = self
        monthPickerView.dataSource = self
        self.addData()
        self.datePickerStackView.isHidden = true
        
        DispatchQueue.main.async {
            print(self.yearPickerView.subviews.count)
//
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.yearPickerView.subviews[1].backgroundColor = UIColor.clear
//
//            print(self.yearPickerView.subviews.count)
//            let topLayer1 = CALayer()
//            topLayer1.frame = CGRect(x: 0,
//                                     y: 0,
//                                     width: self.yearPickerView.subviews[1].frame.width,
//                                     height: 1)
//            topLayer1.backgroundColor = UIColor.black.cgColor
//            let bottomLayer1 = CALayer()
//            bottomLayer1.frame = CGRect(x: 0,
//                                        y: self.yearPickerView.subviews[1].frame.height - 1,
//                                        width: self.yearPickerView.subviews[1].frame.width,
//                                        height: 1)
//            bottomLayer1.backgroundColor = UIColor.black.cgColor
//            self.yearPickerView.subviews[1].layer.addSublayer(topLayer1)
//            self.yearPickerView.subviews[1].layer.addSublayer(bottomLayer1)
//
//
//
//            let topLayer2 = CALayer()
//            topLayer2.frame = CGRect(x: 0,
//                                    y: 0,
//                                    width: self.monthPickerView.subviews[1].frame.width,
//                                    height: 1)
//            topLayer2.backgroundColor = UIColor.black.cgColor
//                        let bottomLayer2 = CALayer()
//            bottomLayer2.frame = CGRect(x: 0,
//                                        y: self.monthPickerView.subviews[1].frame.height - 1,
//                                        width: self.monthPickerView.subviews[1].frame.width,
//                                        height: 1)
//            bottomLayer2.backgroundColor = UIColor.Black4.cgColor
//            self.monthPickerView.subviews[1].layer.addSublayer(topLayer2)
//            self.monthPickerView.subviews[1].layer.addSublayer(bottomLayer2)
            self.monthPickerView.subviews[1].backgroundColor = UIColor.clear
//        }
        
    }

    @IBAction func touchMoreButton(_ sender: Any) {
        if !verify {
            self.view.frame = CGRect(origin:  CGPoint(x:0, y: self.height*0.08), size: CGSize(width: self.width, height: self.height * 0.92))
            UIView.animate(withDuration: 0.5) {
                self.dateView.layoutIfNeeded()
                self.moreButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
            }
            pointOrigin = self.view.frame.origin
            datePickerStackView.isHidden = false
            verify.toggle()
        } else {
            self.view.frame = CGRect(origin: CGPoint(x:0, y: self.height*0.27), size: CGSize(width: self.width, height: self.height * 0.73))
            UIView.animate(withDuration: 0.5) {
                self.dateView.layoutIfNeeded()
                self.moreButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 100.0)
            }
            pointOrigin = self.view.frame.origin
            datePickerStackView.isHidden = true
            verify.toggle()
        }
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    func enableButton() {
        if emotion != nil || depth != nil {
            applyButton.isEnabled = true
            applyButton.backgroundColor = .BlueModalAble
        } else {
            applyButton.isEnabled = false
            applyButton.backgroundColor = .Black6

        }
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
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin!
                }
            }
        }
    }
    
    
    @IBAction func touchCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ListFilterModalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.emotionCollectionView {
            return emotionArray.count
        }
        else {
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
            if depth == indexPath.row{
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
        enableButton()
    }
    
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
        enableButton()
    }
}

extension ListFilterModalViewController: UIPickerViewDelegate {
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return self.view.frame.height * 40/812
//    }
//
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.yearPickerView {
            return year[row]
        }
        return month[row]
    }
 
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        print(view?.frame)
//
//        var label = UILabel()
//        if let tempView = view as? UILabel {
//            label = tempView
//        }
//        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
//        if pickerView == self.yearPickerView {
//            label.text = year[row]
//        } else {
//            label.text = month[row]
//        }
//        label.frame = pickerView.subviews[1].bounds
//        label.sizeToFit()
//        label.textAlignment = .center
//        print("label frmae ")
//        print(label.frame)
//        return label
//    }
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
