//
//  LockViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/02/08.
//

import UIKit

enum LockViewUsage: Int {
    case setting = 0, doubleChecking, verifying
}

class LockViewController: UIViewController {

    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var firstIndicator: UIView!
    @IBOutlet weak var secondIndicator: UIView!
    @IBOutlet weak var thirdIndicator: UIView!
    @IBOutlet weak var fourthIndicator: UIView!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var zerobutton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var stackViewVerticalSpacingConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var lockViewUsage: LockViewUsage?
    private var errorLabelHeight: CGFloat?
    private let stackViewVerticalSpacingRatio: CGFloat = 157/812
    private var lockNumberList: [Int] = []
    private var firstLockNumberList: [Int] = []
    private var secondLockNumberList: [Int] = []
    private lazy var rightButton: UIBarButtonItem = {
        let button: UIBarButtonItem = UIBarButtonItem(image: Constants.Design.Image.btnCloseBlack, style: .plain, target: self, action: #selector(buttonPressed(sender:)))
        button.tag = 0
        button.tintColor = UIColor.Black1
        return button
    }()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeLockViewController()
        self.initializeNavigationBar()
    }
    
    // MARK: - Functions
    
    private func initializeLockViewController() {
        self.indicatorRoundedUp()
        self.hideErrorLabel()
        self.initializeInfoLabel()
        self.stackViewVerticalSpacingConstraint.constant = self.view.frame.height * stackViewVerticalSpacingRatio
    }
    
    private func initializeNavigationBar() {
        let titleLabelText: String
        let titleLabel = UILabel()
        let titleLabelColor = UIColor.Black2Nav
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16)!, NSAttributedString.Key.foregroundColor: titleLabelColor]
        titleLabelText = "암호 잠금"
        titleLabel.attributedText = NSAttributedString(string: titleLabelText, attributes: attributes)
        titleLabel.sizeToFit()
        
        switch self.lockViewUsage {
        case .setting:
            self.navigationItem.rightBarButtonItem = self.rightButton
        case .verifying:
            self.navigationItem.rightBarButtonItem = nil
        default:
            return
        }
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    private func initializeInfoLabel() {
        switch self.lockViewUsage {
        case .setting:
            self.infoLabel.text = "새 암호를 입력해 주세요."
        case .verifying:
            self.infoLabel.text = "현재 암호를 입력해 주세요."
        default:
            return
        }
    }
    
    private func indicatorRoundedUp() {
        self.firstIndicator.round(corners: UIRectCorner.allCorners, cornerRadius: Double(self.firstIndicator.frame.size.height / 2))
        self.secondIndicator.round(corners: UIRectCorner.allCorners, cornerRadius: Double(self.secondIndicator.frame.size.height / 2))
        self.thirdIndicator.round(corners: UIRectCorner.allCorners, cornerRadius: Double(self.thirdIndicator.frame.size.height / 2))
        self.fourthIndicator.round(corners: UIRectCorner.allCorners, cornerRadius: Double(self.fourthIndicator.frame.size.height / 2))
    }
    
    private func updateLockViewController() {
        switch self.lockViewUsage {
        case .setting:
            self.lockViewUsage = .doubleChecking
            self.infoLabel.text = "다시 한 번 입력해주세요."
            self.saveFirstLockNumber()
            self.popAllLockNumberListAndEmptyIndicator()
            print("first \(self.firstLockNumberList)")
            
        case .doubleChecking:
            self.saveSecondLockNumber()
            print("second \(self.secondLockNumberList)")
            if self.doubleCheckingIsValid() {
                self.saveLockNumber()
                self.popToSettingViewController(lockIsUpdated: true)
            } else {
                self.showErrorMessage(message: "입력한 암호와 달라요!")
                self.popAllSecondNumberList()
                self.popAllLockNumberListAndEmptyIndicator()
            }
        case .verifying:
            if self.isValid() {
                self.pushToHomeViewController()
            } else {
                self.showErrorMessage(message: "현재 암호와 달라요!")
                self.popAllLockNumberListAndEmptyIndicator()
            }
        default:
            return
        }
    }
    
    private func saveLockNumber() {
        UserDefaults.standard.setValue(self.makeLockNumberToString(lockNumberList: self.firstLockNumberList), forKey: "LockNumber")
        UserDefaults.standard.setValue(true, forKey: "isLocked")
    }
    
    private func saveFirstLockNumber() {
        for number in self.lockNumberList {
            self.firstLockNumberList.append(number)
        }
    }
    
    private func saveSecondLockNumber() {
        for number in self.lockNumberList {
            self.secondLockNumberList.append(number)
        }
    }
    
    private func makeLockNumberToString(lockNumberList: [Int]) -> String {
        let stringNumberList = lockNumberList.map { (number) -> String in "\(number)" }
        return stringNumberList.joined(separator: "")
    }
    
    private func isValid() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLocked") && self.makeLockNumberToString(lockNumberList: self.lockNumberList) == UserDefaults.standard.string(forKey: "LockNumber")
    }
    
    private func doubleCheckingIsValid() -> Bool {
        guard self.secondLockNumberList.count == 4,
              self.firstLockNumberList.count == 4 else {
            return false
        }
        for (firstNum, secondNum) in zip(self.firstLockNumberList, self.secondLockNumberList) where firstNum != secondNum {
            return false
        }
        return true
    }
    
    private func appendLockNumberAndFillIndicator(lockNumber: Int) {
        self.appendLockNumber(lockNumber: lockNumber)
        self.fillIndicator()
        if self.lockNumberIsFilled() {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100), execute: {
                self.updateLockViewController()
            })
            
        }
    }
    
    private func appendLockNumber(lockNumber: Int) {
        guard self.lockNumberList.count < 4 else { return }
        self.lockNumberList.append(lockNumber)
    }
    
    private func popLockNumberListAndEmptyIndicator() {
        self.popLockNumber()
        self.emptyIndicator()
    }
    
    private func popAllLockNumberListAndEmptyIndicator() {
        for _ in 1...4 {
            self.popLockNumberListAndEmptyIndicator()
        }
    }
    
    private func popAllSecondNumberList() {
        self.secondLockNumberList = []
    }
    
    private func lockNumberIsFilled() -> Bool {
        return self.lockNumberList.count == 4
    }
    
    private func popLockNumber() {
        guard self.lockNumberList.count > 0 else { return }
        let _ = self.lockNumberList.popLast()
    }
    
    private func fillIndicator() {
        switch self.lockNumberList.count {
        case 1:
            self.firstIndicator.backgroundColor = UIColor.Blue3
        case 2:
            self.secondIndicator.backgroundColor = UIColor.Blue3
        case 3:
            self.thirdIndicator.backgroundColor = UIColor.Blue3
        case 4:
            self.fourthIndicator.backgroundColor = UIColor.Blue3
        default:
            return
        }
    }
    
    private func emptyIndicator() {
        switch self.lockNumberList.count {
        case 3:
            self.fourthIndicator.backgroundColor = UIColor.Blue5
        case 2:
            self.thirdIndicator.backgroundColor = UIColor.Blue5
        case 1:
            self.secondIndicator.backgroundColor = UIColor.Blue5
        case 0:
            self.firstIndicator.backgroundColor = UIColor.Blue5
        default:
            return
        }
    }
    
    private func hideErrorLabel() {
        self.errorLabelHeight = self.errorLabel.frame.height
        self.errorLabel.isHidden = true
        self.errorLabel.frame.size.height = 0
    }
    
    private func showErrorMessage(message: String) {
        self.errorLabel.isHidden = false
        self.errorLabel.text = message
        guard let errorLabelHeight = self.errorLabelHeight else { return }
        self.errorLabel.frame.size.height = errorLabelHeight
    }
    
    private func popToSettingViewController(lockIsUpdated: Bool) {
        guard let settingViewController = self.navigationController?.viewControllers.filter({$0 is SettingViewController}).first as? SettingViewController else {
            return
        }
        settingViewController.lockIsUpdated = lockIsUpdated
        self.navigationController?.popToViewController(settingViewController, animated: true)
    }
    
    private func pushToHomeViewController() {
        let homeStoryboard = UIStoryboard(name: Constants.Name.homeStoryboard, bundle: nil)
        guard let homeViewController = homeStoryboard.instantiateViewController(identifier: Constants.Identifier.homeViewController) as? HomeViewController else { return }
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    @objc private func buttonPressed(sender: UIBarButtonItem) {
        switch sender.tag {
        case 0:
            switch self.lockViewUsage {
            case .setting, .doubleChecking:
                self.popToSettingViewController(lockIsUpdated: false)
            default:
                return
            }
        default:
            return
        }
    }
    
    @IBAction func oneButtonTouch(_ sender: UIButton) {
        self.appendLockNumberAndFillIndicator(lockNumber: 1)
    }
    @IBAction func twoButtonTouch(_ sender: UIButton) {
        self.appendLockNumberAndFillIndicator(lockNumber: 2)
    }
    @IBAction func threeButtonTouch(_ sender: UIButton) {
        self.appendLockNumberAndFillIndicator(lockNumber: 3)
    }
    @IBAction func fourButtonTouch(_ sender: UIButton) {
        self.appendLockNumberAndFillIndicator(lockNumber: 4)
    }
    @IBAction func fiveButtonTouch(_ sender: UIButton) {
        self.appendLockNumberAndFillIndicator(lockNumber: 5)
    }
    @IBAction func sixButtonTouch(_ sender: UIButton) {
        self.appendLockNumberAndFillIndicator(lockNumber: 6)
    }
    @IBAction func sevenButtonTouch(_ sender: UIButton) {
        self.appendLockNumberAndFillIndicator(lockNumber: 7)
    }
    @IBAction func eightButtonTouch(_ sender: UIButton) {
        self.appendLockNumberAndFillIndicator(lockNumber: 8)
    }
    @IBAction func nineButtonTouch(_ sender: UIButton) {
        self.appendLockNumberAndFillIndicator(lockNumber: 9)
    }
    @IBAction func zeroButtonTouch(_ sender: UIButton) {
        self.appendLockNumberAndFillIndicator(lockNumber: 0)
    }
    @IBAction func backButtonTouch(_ sender: UIButton) {
        self.popLockNumberListAndEmptyIndicator()
    }
}
