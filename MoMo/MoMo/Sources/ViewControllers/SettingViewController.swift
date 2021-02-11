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

enum SettingAlertViewUsage: Int {
    case logout = 0, withdrawal
}

class SettingViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var settingTableView: UITableView!
    
    // MARK: - Properties
    
    var settingViewUsage: SettingViewUsage?
    var lockIsUpdated: Bool = false
    private var settingAlerViewUsage: SettingAlertViewUsage?
    private var toastView: ToastView?
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
    private lazy var withdrawalButton: UIButton = {
        let button: UIButton = UIButton()
        let buttonLabelText: String = "회원탈퇴"
        let buttonLabelColor = UIColor.Black6
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!, NSAttributedString.Key.foregroundColor: buttonLabelColor]
        let buttonLabelAttributedText = NSAttributedString(string: buttonLabelText, attributes: attributes)
        button.setAttributedTitle(buttonLabelAttributedText, for: .normal)
        button.addTarget(self, action: #selector(touchWithDrawalButton(sender:)), for: .touchUpInside)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.lockIsUpdated {
            self.attachToastViewWithAnimation(message: "암호 설정이 완료되었습니다")
            self.lockIsUpdated = false
        }
        self.updateIsLocked()
        self.updateControlSwitch()
        self.settingTableView.reloadData()
    }
    
    // MARK: - Functions
    
    private func initializeSettingViewController() {
        self.initializeSettingTableView()
        switch self.settingViewUsage {
        case .setting:
            self.attachVersionLabel()
            self.updateVersion()
            self.updateVersionLabelConstraints()
            self.updateSellInfosForSetting()
        case .info:
            self.hideVersionLabel()
            self.updateSellInfosForInfo()
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
    
    private func initializeSettingTableView() {
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        self.settingTableView.register(UINib(nibName: Constants.Name.settingTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.settingTableViewCell)
        self.settingTableView.separatorStyle = .none
    }
    
    private func hasLock() -> Bool {
        return UserDefaults.standard.object(forKey: "isLocked") != nil
    }
    
    private func updateIsLocked() {
        if self.hasLock() {
            self.isLocked = UserDefaults.standard.bool(forKey: "isLocked")
        }
    }
    
    private func updateIsLocked(isLocked: Bool) {
        UserDefaults.standard.setValue(isLocked, forKey: "isLocked")
        self.isLocked = isLocked
    }
    
    private func updateControlSwitch() {
        self.controlSwitch.isOn = self.isLocked
    }
    
    private func updateSellInfosForSetting() {
        self.cellInfos = [
            (image: Constants.Design.Image.icUser, labelText: "내 정보", touchAction: self.pushToInfoViewController),
            (image: Constants.Design.Image.icLock, labelText: "암호 잠금", touchAction: { self.hasLock() ? {}() : self.pushToLockViewController()}),
            (image: Constants.Design.Image.icLicense, labelText: "오픈 소스 라이선스", touchAction: self.pushToOpenSourceLicenseViewController),
            (image: Constants.Design.Image.icTeam, labelText: "Team MOMO", touchAction: self.pushToTeamMomoViewController),
            (image: Constants.Design.Image.icInstaLogo, labelText: "MOMO 인스타그램", touchAction: self.pushToMomoInstaViewController)
        ]
    }
    
    private func updateSellInfosForInfo() {
        self.cellInfos = [
            (image: Constants.Design.Image.icPwChange, labelText: "비밀번호 변경", touchAction: self.pushToPasswordChangeViewController),
            (image: Constants.Design.Image.icDoc1, labelText: "개인정보처리방침", touchAction: self.pushToPersonalTermViewController),
            (image: Constants.Design.Image.icDoc2, labelText: "서비스이용약관", touchAction: self.pushToServiceTermViewController),
            (image: Constants.Design.Image.icLogout, labelText: "로그아웃", touchAction: {
                self.settingAlerViewUsage = .logout
                self.attachAlertModalView(alertLabelText: "정말 로그아웃 하시겠어요?\n일기를 다시 쓰려면 로그인해 주세요!")
            }),
            (image: UIImage(), labelText: "", touchAction: {})
        ]
    }
    
    private func attachSwitch(superView: UITableViewCell) {
        superView.addSubview(self.controlSwitch)
        self.updateSwitchConstraints(superView: superView)
    }
    
    private func attachResetButton(superView: UITableViewCell) {
        superView.addSubview(self.resetButton)
        self.updateResetButtonConstraints(superView: superView)
    }
    
    private func attachAlertModalView(alertLabelText: String) {
        self.alertModalView = AlertModalView.instantiate(alertLabelText: alertLabelText, leftButtonTitle: "확인", rightButtonTitle: "취소")
        if let alertModalView = self.alertModalView {
            alertModalView.alertModalDelegate = self
            self.view.insertSubview(alertModalView, aboveSubview: self.view)
            self.updateAlertModalViewConstraints(view: alertModalView)
        }
    }
    
    private func attachVersionLabel() {
        self.settingTableView.addSubview(self.versionLabel)
    }
    
    private func attachToastView(message: String) {
        self.toastView = ToastView.instantiate(message: message)
        guard let toastView = self.toastView else { return }
        toastView.alpha = 0.0
        self.view.insertSubview(toastView, aboveSubview: self.view)
        self.updateToastViewConstraints(view: toastView)
    }
    
    private func attachWithdrawalButton(superView: UITableViewCell) {
        superView.addSubview(self.withdrawalButton)
        self.updateWithdrawalButtonConstraints(superView: superView)
    }
    
    private func attachToastViewWithAnimation(message: String) {
        self.attachToastView(message: message)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            animations: {
                self.toastView?.alpha = 1.0
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0.5,
                    animations: {
                        self.toastView?.alpha = 0.0
                    },
                    completion: { _ in
                        self.detachToastView()
                    }
                )
            }
        )
    }
    
    private func detachToastView() {
        self.toastView?.removeFromSuperview()
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
    
    private func updateWithdrawalButtonConstraints(superView: UITableViewCell) {
        self.withdrawalButton.snp.makeConstraints { make in
            make.centerY.equalTo(superView.snp.centerY)
            make.trailing.equalTo(superView.snp.trailing).inset(7)
        }
    }
    
    private func updateAlertModalViewConstraints(view: UIView) {
        view.snp.makeConstraints({ (make) in
            make.width.height.centerX.centerY.equalTo(self.view)
        })
    }
    
    private func updateToastViewConstraints(view: UIView) {
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
        let lockStoryboard = UIStoryboard(name: Constants.Name.lockStoryboard, bundle: nil)
        guard let lockViewController = lockStoryboard.instantiateViewController(identifier: Constants.Identifier.lockViewController) as? LockViewController else { return }
        lockViewController.lockViewUsage = .setting
        self.navigationController?.pushViewController(lockViewController, animated: true)
    }
    
    private func pushToOpenSourceLicenseViewController() {
        let openSourceStoryboard = UIStoryboard(name: Constants.Name.openSourceStoryboard, bundle: nil)
        guard let openSourceViewController = openSourceStoryboard.instantiateViewController(identifier: Constants.Identifier.openSourceViewController) as? OpenSourceViewController else {
            return
        }
        self.navigationController?.pushViewController(openSourceViewController, animated: true)
    }
    
    private func pushToPersonalTermViewController() {
        let personalTermStoryboard = UIStoryboard(name: Constants.Name.personalTermStoryboard, bundle: nil)
        guard let personalTermViewController = personalTermStoryboard.instantiateViewController(identifier: Constants.Identifier.personalTermViewController) as? PersonalTermViewController else {
            return
        }
        self.navigationController?.pushViewController(personalTermViewController, animated: true)
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
    
    private func popToHomeViewController() {
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
        if self.hasLock() {
            if sender.isOn {
                self.showResetButton()
                self.updateIsLocked(isLocked: true)
            } else {
                self.hideResetButton()
                self.updateIsLocked(isLocked: false)
            }
        } else {
            self.pushToLockViewController()
        }
    }
    
    @objc func touchResetButton(sender: UIButton) {
        self.pushToLockViewController()
    }
    
    @objc func touchWithDrawalButton(sender: UIButton) {
        self.settingAlerViewUsage = .withdrawal
        self.attachAlertModalView(alertLabelText: "정말 탈퇴 하시겠어요?\n작성된 일기를 다시 볼 수 없어요!")
    }
}

// MARK: - AlertModalViewDelegate

extension SettingViewController: AlertModalDelegate {
    func leftButtonTouchUp(button: UIButton) {
        switch self.settingAlerViewUsage {
        case .logout:
            self.popToLoginViewController()
        case .withdrawal:
            self.deleteUserWithAPI(userId: APIConstants.userId, completion: {
                self.deleteUserIdAndToken()
                self.popToLoginViewController()
            })
        default:
            return
        }
        
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
            self.controlSwitch.isOn = self.isLocked
            self.attachResetButton(superView: cell)
            self.resetButton.isHidden = !self.isLocked
        }
        
        if self.settingViewUsage == .info && cellInfo.labelText.isEmpty {
            self.attachWithdrawalButton(superView: cell)
            let separatorView = cell.subviews.first?.subviews.filter {$0.restorationIdentifier == "SeparatorView"}.first
            separatorView?.isHidden = true
        }
        return cell
    }
}

// MARK: - API Services

extension SettingViewController {
    private func deleteUserWithAPI(userId: Int, completion: @escaping () -> Void) {
        UserService.shared.deleteUser(userId: userId) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    completion()
                }
            case .requestErr(let errorMessage):
                print(errorMessage)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}
