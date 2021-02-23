//
//  StatisticsViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/29.
//

import UIKit

class StatisticsViewController: UIViewController {

    // MARK: - Constants:
    let moodText: String? = "감정"
    let depthText: String? = "깊이"
    
    var depthButtonSubLayer: CALayer?
    var moodButtonSubLayer: CALayer?
    var dateModal: HomeModalViewController?
    var year: Int? = 2021
    var month: Int? = 01
    var depthData: [Int] = [0, 0, 0, 0, 0, 0, 0]
    var emotionData: [Int] = [0, 0, 0, 0, 0, 0, 0, 0]
    
    // MARK: - IBOutlets
    @IBOutlet weak var depthButton: UIButton!
    @IBOutlet weak var moodButton: UIButton!
    @IBOutlet weak var statContainerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statNumLabel: UILabel!
    
    // MARK: - Override LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let unwrappedYear = year, let unwrappedMonth = month else {
            return
        }
        updateLabelText()
        addTapRecognizerToDateLabel()
        initializeDateModal()
        initializeNavigationItem()
        initializeSubLayer()
        getDiaryStatisticsWithAPI("\(unwrappedYear)", "\(unwrappedMonth)")
    }

    // MARK: - Private Function
    
    private func addTapRecognizerToDateLabel() {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapDateLabel(_:)))
        self.dateLabel.isUserInteractionEnabled = true
        self.dateLabel.addGestureRecognizer(tapRecognizer)
    }
    
    private func initializeSubLayer() {
        let depthLayer = CALayer()
        depthLayer.frame = CGRect(x: 0,
                             y: moodButton.bounds.height-3,
                             width: moodButton.bounds.width,
                             height: 3)
        depthLayer.backgroundColor = UIColor.Blue1.cgColor
        depthButtonSubLayer = depthLayer
        let moodLayer = CALayer()
        moodLayer.frame = CGRect(x: 0,
                             y: moodButton.bounds.height-3,
                             width: moodButton.bounds.width,
                             height: 3)
        moodLayer.backgroundColor = UIColor.Blue1.cgColor
        moodButtonSubLayer = moodLayer
    }
    
    private func initializeDateModal() {
        dateModal = HomeModalViewController()
    }
    
    private func initializeButtonIsSelected() {
        depthButton.isSelected = false
        moodButton.isSelected = true
    }
    
    private func initializeIntialStatView() {
        changeMoodButtonSelectedInterface()
        addButtonSublayer()
        showMoodStatView()
    }
    
    private func updateLabelText() {
        guard let unwrappedYear = year, let unwrappedMonth = month else {
            return
        }
        let monthString = String(format: "%02d", unwrappedMonth)
        dateLabel.text = ("\(unwrappedYear)년 " + monthString + "월")
    }
    
    private func initializeNavigationItem() {
        let backButton = UIBarButtonItem(image: Constants.Design.Image.btnBackBlack, style: .plain, target: self, action: #selector(touchBackButton))
        backButton.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "이 달의 통계"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.Black1]
        
    }
    
    private func removeChildView() {
        for viewController in children {
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }
    
    private func showMoodStatView() {
        guard let moodStatViewController = storyboard?.instantiateViewController(identifier: Constants.Identifier.moodStatViewController) as? MoodStatViewController else {
            return
        }
        moodStatViewController.moodStatData = emotionData
        addChild(moodStatViewController)
        moodStatViewController.view.frame = statContainerView.bounds
        statContainerView.addSubview(moodStatViewController.view)
    }
    
    private func showDepthStatView() {
        guard let depthStatViewController = storyboard?.instantiateViewController(identifier: Constants.Identifier.depthStatViewController) as? DepthStatViewController else {
            return
        }
        depthStatViewController.depthStatData = depthData
        addChild(depthStatViewController)
        depthStatViewController.view.frame = statContainerView.bounds
        statContainerView.addSubview(depthStatViewController.view)
    }
    
    private func makeUnselectedButtonTitle(_ text: String) -> NSMutableAttributedString {
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .ultraLight),
                     NSAttributedString.Key.foregroundColor: UIColor.Black3List]
        let attrText = NSMutableAttributedString(string: text, attributes: attrs)
        return attrText
    }
    
    private func makeSelectedButtonTitle(_ text: String) -> NSMutableAttributedString {
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .semibold),
                     NSAttributedString.Key.foregroundColor: UIColor.Blue1]
        let attrText = NSMutableAttributedString(string: text, attributes: attrs)
        return attrText
    }
        
    private func changeMoodButtonSelectedInterface() {
        guard let depth = depthText, let mood = moodText else {
            return
        }
        moodButton.titleLabel?.attributedText = makeSelectedButtonTitle(mood)
        depthButton.titleLabel?.attributedText = makeUnselectedButtonTitle(depth)
    }
    
    private func changeDepthButtonSelectedInterface() {
        guard let depth = depthText, let mood = moodText else {
            return
        }
        moodButton.titleLabel?.attributedText = makeUnselectedButtonTitle(mood)
        depthButton.titleLabel?.attributedText = makeSelectedButtonTitle(depth)
    }
    
    private func addButtonSublayer() {
        guard let moodLayer = moodButtonSubLayer, let depthLayer = depthButtonSubLayer else {
            return
        }
        if moodButton.isSelected {
            moodButton.layer.addSublayer(moodLayer)
            depthLayer.removeFromSuperlayer()
        } else {
            depthButton.layer.addSublayer(depthLayer)
            moodLayer.removeFromSuperlayer()
        }
    }
    
    private func presentDateModal() {
        guard let modal = dateModal, let unwrappedYear = self.year, let unwrappedMonth = self.month else {
            return
        }
        modal.year = unwrappedYear
        modal.month = unwrappedMonth
        modal.statModalViewDelegate = self
        modal.modalPresentationStyle = .custom
        modal.transitioningDelegate = self
        self.present(modal, animated: true, completion: nil)
    }
    
    private func getDiaryStatisticsWithAPI (_ paramYear: String, _ paramMonth: String) {
        DiaryStatistics.shared.getDiaryStatistics(userId: "\(APIConstants.userId)", year: paramYear, month: paramMonth) { networkResult in
            switch networkResult {

            case .success(let data):
                guard let unwrappedData = data as? Statistics else {
                    return
                }
                self.updateMoodDepthData(unwrappedData.emotionCounts,
                                    unwrappedData.depthCounts)
                self.presentStatAfterServer()
                
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr in getDiaryStatisticsWithAPI")
            case .serverErr:
                print("serverErr in getDiaryStatisticsWithAPI")
            case .networkFail:
                print("networkFail in getDiaryStatisticsWithAPI")
            }
        }
    }
    
    private func presentStatAfterServer() {
        if !depthButton.isSelected && !moodButton.isSelected {
            self.initializeButtonIsSelected()
            self.initializeIntialStatView()
        } else if moodButton.isSelected {
            removeChildView()
            showMoodStatView()
        } else {
            removeChildView()
            showDepthStatView()
        }
    }
    
    private func updateStatNumLabel(_ cnt: Int) {
        self.statNumLabel.text = "\(cnt)개의 일기"
    }
    
    private func updateMoodDepthData(_ emotion: [EmotionCount], _ depth: [DepthCount]) {
        depthData = [0, 0, 0, 0, 0, 0, 0]
        emotionData = [0, 0, 0, 0, 0, 0, 0, 0]
        
        for idx in 0..<emotion.count {
            emotionData[(emotion[idx].emotionID) - 1] = emotion[idx].count
        }
        for idx in 0..<depth.count {
            depthData[depth[idx].depth] = depth[idx].count
        }
        updateStatNumLabel(depthData.reduce(0, +))
        
    }
    
    // MARK: - Selector Function
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapDateLabel(_ sender: UITapGestureRecognizer) {
        presentDateModal()
    }
    
    // MARK: - IBActions
    
    @IBAction func touchMoodButton(_ sender: Any) {
        if !moodButton.isSelected {
            moodButton.isSelected.toggle()
            depthButton.isSelected.toggle()
            changeMoodButtonSelectedInterface()
            removeChildView()
            showMoodStatView()
            addButtonSublayer()
        }
    }
 
    @IBAction func touchDepthButton(_ sender: Any) {
        if moodButton.isSelected {
            moodButton.isSelected.toggle()
            depthButton.isSelected.toggle()
            changeDepthButtonSelectedInterface()
            removeChildView()
            showDepthStatView()
            addButtonSublayer()
           
        }
    }
    
    @IBAction func touchModalButton(_ sender: Any) {
        presentDateModal()
    }
}

extension StatisticsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        HomeModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension StatisticsViewController: StatModalViewDelegate {
    func passData(year: Int, month: Int) {
        self.year = year
        self.month = month
        self.updateLabelText()
        self.getDiaryStatisticsWithAPI("\(year)", "\(month)")
    }
}
