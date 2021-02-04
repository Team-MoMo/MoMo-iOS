//
//  SettingViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/02/02.
//

import UIKit

typealias SettingCellInfo = (image: UIImage?, labelText: String, touchAction: () -> Void)

enum SettingViewUsage: Int {
    case setting = 0, info
}

class SettingViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var settingTableView: UITableView!
    
    // MARK: - Properties
    
    var settingViewUsage: SettingViewUsage?
    private let cellHeight: CGFloat = 64
    private var cellInfos: [SettingCellInfo]?
    private var isLocked: Bool = false
    private var alertModalView: AlertModalView?
    private lazy var leftButton: UIBarButtonItem = {
        let button: UIBarButtonItem = UIBarButtonItem(image: Constants.Design.Image.btnBackBlack, style: .plain, target: self, action: #selector(buttonPressed(sender:)))
        button.tag = 0
        button.tintColor = UIColor.Black1
        return button
    }()
    private lazy var controlSwitch: UISwitch = {
        let swicth: UISwitch = UISwitch()
        swicth.isOn = self.isLocked
        swicth.addTarget(self, action: #selector(onClickSwitch(sender:)), for: UIControl.Event.valueChanged)
        return swicth
    }()
    private lazy var resetButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(Constants.Design.Image.btnResetting, for: .normal)
        button.addTarget(self, action: #selector(touchResetButton(sender:)), for: .touchUpInside)
        return button
    }()
    private lazy var versionLabel: UILabel = {
        let label: UILabel = UILabel()
        let labelText: String = "Ver. 1.0"
        let labelColor = UIColor.Blue4
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-Medium", size: 14)!, NSAttributedString.Key.foregroundColor: labelColor]
        label.attributedText = NSAttributedString(string: labelText, attributes: attributes)
        label.sizeToFit()
        return label
    }()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeSettingViewController()
        self.initializeNavigationBar()
    }
    
    // MARK: - Functions
    
    private func initializeSettingViewController() {
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        self.settingTableView.register(UINib(nibName: Constants.Name.settingTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.settingTableViewCell)
        self.settingTableView.separatorStyle = .none
        
        switch self.settingViewUsage {
        case .setting:
            self.attachVersionLabel()
            self.updateVersion()
            self.updateVersionLabelConstraints()
            if self.hasLock() {
                self.isLocked = UserDefaults.standard.bool(forKey: "isLocked")
            }
            self.cellInfos = [
                (image: Constants.Design.Image.icUser, labelText: "내 정보", touchAction: self.pushToInfoViewController),
                (image: Constants.Design.Image.icLock, labelText: "암호 잠금", touchAction: self.pushToLockViewController),
                (image: Constants.Design.Image.icLicense, labelText: "오픈 소스 라이선스", touchAction: self.pushToOpenSourceLicenseViewController),
                (image: Constants.Design.Image.icTeam, labelText: "Team MOMO", touchAction: self.pushToTeamMomoViewController),
                (image: Constants.Design.Image.icInstaLogo, labelText: "MOMO 인스타그램", touchAction: self.pushToMomoInstaViewController)
            ]
        case .info:
            self.hideVersionLabel()
            self.cellInfos = [
                (image: Constants.Design.Image.icPwChange, labelText: "비밀번호 변경", touchAction: self.pushToPasswordChangeViewController),
                (image: Constants.Design.Image.icDoc1, labelText: "개인정보처리방침", touchAction: self.pushToPersonalTermViewController),
                (image: Constants.Design.Image.icDoc2, labelText: "서비스이용약관", touchAction: self.pushToServiceTermViewController),
                (image: Constants.Design.Image.icLogout, labelText: "로그아웃", touchAction: self.attachAlertModalView)
            ]
        default:
            return
        }
    }
    
    private func initializeNavigationBar() {
        let titleLabelText: String
        let titleLabel = UILabel()
        let titleLabelColor = UIColor.Black2Nav
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16)!, NSAttributedString.Key.foregroundColor: titleLabelColor]
        
        switch self.settingViewUsage {
        case .setting:
            titleLabelText = "환경설정"
        case .info:
            titleLabelText = "내 정보"
        default:
            return
        }
        
        titleLabel.attributedText = NSAttributedString(string: titleLabelText, attributes: attributes)
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItem = self.leftButton
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    private func hasLock() -> Bool {
        return UserDefaults.standard.object(forKey: "isLocked") != nil
    }
    
    private func popToHomeViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func attachSwitch(superView: UITableViewCell) {
        superView.addSubview(self.controlSwitch)
        self.updateSwitchConstraints(superView: superView)
    }
    
    private func attachResetButton(superView: UITableViewCell) {
        superView.addSubview(self.resetButton)
        self.updateResetButtonConstraints(superView: superView)
    }
    
    private func attachAlertModalView() {
        self.alertModalView = AlertModalView.instantiate(
            alertLabelText: "정말 로그아웃 하시겠어요?\n일기를 다시 쓰려면 로그인해 주세요!",
            leftButtonTitle: NSMutableAttributedString(string: "확인"),
            rightButtonTitle: NSMutableAttributedString(string: "취소")
        )
        if let alertModalView = self.alertModalView {
            alertModalView.alertModalDelegate = self
            self.view.insertSubview(alertModalView, aboveSubview: self.view)
            self.updateAlertModalViewConstraints(view: alertModalView)
        }
    }
    
    private func attachVersionLabel() {
        self.settingTableView.addSubview(self.versionLabel)
    }
    
    private func showResetButton() {
        self.resetButton.isHidden = false
    }
    
    private func hideResetButton() {
        self.resetButton.isHidden = true
    }
    
    private func hideVersionLabel() {
        self.versionLabel.isHidden = true
    }
    
    private func updateVersion() {
        let nsObject = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        guard let version = nsObject as? String else { return }
        self.versionLabel.text = "Ver. \(version)"
    }
    
    private func updateVersionLabelConstraints() {
        self.versionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(15)
        }
    }
    
    private func updateResetButtonConstraints(superView: UITableViewCell) {
        self.resetButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerY.equalTo(superView.snp.centerY)
            make.trailing.equalTo(superView.snp.trailing).inset(90)
        }
    }
    
    private func updateSwitchConstraints(superView: UITableViewCell) {
        self.controlSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(superView.snp.centerY)
            make.trailing.equalTo(superView.snp.trailing).inset(26)
        }
    }
    
    private func updateAlertModalViewConstraints(view: UIView) {
        view.snp.makeConstraints({ (make) in
            make.width.height.centerX.centerY.equalTo(self.view)
        })
    }
    
    private func deleteUserIdAndToken() {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "userId")
    }
    
    private func pushToInfoViewController() {
        let settingStoryboard = UIStoryboard(name: Constants.Name.settingStoryboard, bundle: nil)
        guard let infoViewController = settingStoryboard.instantiateViewController(identifier: Constants.Identifier.settingViewController) as? SettingViewController else { return }
        infoViewController.settingViewUsage = .info
        self.navigationController?.pushViewController(infoViewController, animated: true)
    }
    
    private func pushToLockViewController() {
        
    }
    
    private func pushToOpenSourceLicenseViewController() {
        let openSourceStoryboard = UIStoryboard(name: Constants.Name.openSourceStoryboard, bundle: nil)
        guard let openSourceViewController = openSourceStoryboard.instantiateViewController(identifier: Constants.Identifier.openSourceViewController) as? OpenSourceViewController else {
            return
        }
        self.navigationController?.pushViewController(openSourceViewController, animated: true)
    }
    
    private func pushToPersonalTermViewController() {
        
    }
    
    private func pushToServiceTermViewController() {
        
    }
    
    private func pushToPasswordChangeViewController() {
        
    }
    
    private func pushToTeamMomoViewController() {
        
    }
    
    private func pushToMomoInstaViewController() {
        
    }
    
    private func popToLoginViewController() {
        self.deleteUserIdAndToken()
        if let loginViewController = self.navigationController?.viewControllers.filter({$0 is LoginViewController}).first as? LoginViewController {
            print("기존에 있던 login view 찾았음!")
            self.navigationController?.popToViewController(loginViewController, animated: true)
        } else {
            guard let homeViewController = self.navigationController?.viewControllers.filter({$0 is HomeViewController}).first as? HomeViewController else {
                return
            }
            homeViewController.isFromLogout = true
            self.navigationController?.popToViewController(homeViewController, animated: true)
        }
    }
    
    private func popToSettingViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func buttonPressed(sender: UIBarButtonItem) {
        switch sender.tag {
        case 0:
            switch self.settingViewUsage {
            case .setting:
                self.popToHomeViewController()
            case .info:
                self.popToSettingViewController()
            default:
                return
            }
        default:
            return
        }
    }
    
    @objc func onClickSwitch(sender: UISwitch) {
        if sender.isOn {
            self.showResetButton()
        } else {
            self.hideResetButton()
        }
        self.isLocked = sender.isOn
        UserDefaults.standard.setValue(self.isLocked, forKey: "isLocked")
    }
    
    @objc func touchResetButton(sender: UIButton) {
        print("암호 변경 뷰 띄우기")
    }
}

// MARK: - AlertModalViewDelegate

extension SettingViewController: AlertModalDelegate {
    func leftButtonTouchUp(button: UIButton) {
        self.popToLoginViewController()
    }
    
    func rightButtonTouchUp(button: UIButton) {
        self.alertModalView?.removeFromSuperview()
    }
}

// MARK: - UITableViewDelegate

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellInfos = self.cellInfos else { return }
        cellInfos[indexPath.row].touchAction()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
}

// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cellInfos = self.cellInfos else { return 0 }
        return cellInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellInfos = self.cellInfos else { return UITableViewCell() }
        let cellInfo = cellInfos[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.settingTableViewCell) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setCell(image: cellInfo.image, labelText: cellInfo.labelText)
        
        if self.settingViewUsage == .setting && cellInfo.image == Constants.Design.Image.icLock {
            self.attachSwitch(superView: cell)
            self.attachResetButton(superView: cell)
            self.resetButton.isHidden = !self.isLocked
        }
        return cell
    }
}
