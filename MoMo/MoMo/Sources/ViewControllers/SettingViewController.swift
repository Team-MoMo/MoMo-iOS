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
    var passwordIsUpdated: Bool = false
    private var settingAlertViewUsage: SettingAlertViewUsage?
    private var toastView: ToastView?
    private let cellHeight: CGFloat = 64
    private var cellInfos: [SettingCellInfo]?
    private var isLocked: Bool = false
    private var alertModalView: AlertModalView?
    private lazy var leftButton: UIBarButtonItem = {
        let button: UIBarButtonItem = UIBarButtonItem(image: Constants.Design.Image.btnBackBlack, style: .plain, target: self, action: #selector(touchNavigationButton(sender:)))
        button.tag = 0
        button.tintColor = UIColor.Black1
        return button
    }()
    private lazy var controlSwitch: UISwitch = {
        let swicth: UISwitch = UISwitch()
        swicth.isOn = self.isLocked
        swicth.addTarget(self, action: #selector(touchSwitch(sender:)), for: UIControl.Event.valueChanged)
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
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedString.Key.foregroundColor: buttonLabelColor]
        let buttonLabelAttributedText = NSAttributedString(string: buttonLabelText, attributes: attributes)
        button.setAttributedTitle(buttonLabelAttributedText, for: .normal)
        button.addTarget(self, action: #selector(touchWithDrawalButton(sender:)), for: .touchUpInside)
        return button
    }()
    private lazy var versionLabel: UILabel = {
        let label: UILabel = UILabel()
        let labelText: String = "Ver. 1.0"
        let labelColor = UIColor.Blue4
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium), NSAttributedString.Key.foregroundColor: labelColor]
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
        self.updateIsLocked()
        self.updateControlSwitch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.lockIsUpdated {
            self.attachToastViewWithAnimation(message: "암호 설정이 완료되었습니다")
            self.lockIsUpdated = false
        }
        if self.passwordIsUpdated {
            self.attachToastViewWithAnimation(message: "비밀번호가 변경되었습니다")
            self.passwordIsUpdated = false
        }
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
        self.settingTableView.backgroundColor = .white
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        self.settingTableView.register(UINib(nibName: Constants.Name.settingTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.settingTableViewCell)
        self.settingTableView.separatorStyle = .none
    }
    
    private func hasLock() -> Bool {
        return UserDefaults.standard.object(forKey: "isLocked") != nil
    }
    
    func isSocialLogin() -> Bool {
        if UserDefaults.standard.object(forKey: "loginType") != nil {
            guard let loginType = UserDefaults.standard.string(forKey: "loginType") else { return false }
            if ["apple", "google", "kakao"].contains(loginType) {
                return true
            }
        }
        return false
    }
    
    private func updateIsLocked() {
        if self.hasLock() {
            self.isLocked = UserDefaults.standard.bool(forKey: "isLocked")
        }
    }
    
    private func updateControlSwitch() {
        if self.lockIsUpdated {
            self.controlSwitch.isOn = self.isLocked
            self.controlSwitch.isOn ? self.showResetButton() : self.hideResetButton()
        }
        self.settingTableView.reloadData()
    }
    
    private func updateSellInfosForSetting() {
        self.cellInfos = [
            (image: Constants.Design.Image.icUser, labelText: "내 정보", touchAction: self.pushToInfoViewController),
            (image: Constants.Design.Image.icLock, labelText: "암호 잠금", touchAction: {}),
            (image: Constants.Design.Image.icLicense, labelText: "오픈 소스 라이선스", touchAction: self.pushToOpenSourceLicenseViewController),
            (image: Constants.Design.Image.icTeam, labelText: "Team MOMO", touchAction: self.pushToTeamMomoViewController),
            (image: Constants.Design.Image.icInstaLogo, labelText: "MOMO 인스타그램", touchAction: self.openTeamMomoInstagram),
            (image: nil, labelText: "일기 데이터 다운받기", touchAction: { self.pushToServiceEndViewController() })
        ]
    }
    
    private func updateSellInfosForInfo() {
        self.cellInfos = [
            (image: Constants.Design.Image.icPwChange, labelText: "비밀번호 변경", touchAction: self.pushToChangePasswordViewController),
            (image: Constants.Design.Image.icDoc1, labelText: "개인정보처리방침", touchAction: self.pushToPersonalTermViewController),
            (image: Constants.Design.Image.icDoc2, labelText: "서비스이용약관", touchAction: self.pushToServiceTermViewController),
            (image: Constants.Design.Image.icLogout, labelText: "로그아웃", touchAction: {
                self.settingAlertViewUsage = .logout
                self.attachAlertModalView(alertLabelText: "정말 로그아웃 하시겠어요?\n일기를 다시 쓰려면 로그인해 주세요!")
            }),
            (image: UIImage(), labelText: "", touchAction: {})
        ]
        
        if self.isSocialLogin() {
            self.cellInfos = self.cellInfos?.filter { cell in cell.image != Constants.Design.Image.icPwChange }
        }
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
    
    private func deleteUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "loginType")
        if self.hasLock() {
            UserDefaults.standard.removeObject(forKey: "isLocked")
        }
    }
  
    private func updateVersion() {
        let nsObject = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        guard let version = nsObject as? String else { return }
        self.versionLabel.text = "Ver. \(version)"
    }
    
    private func attachSwitch(superView: UITableViewCell) {
        superView.addSubview(self.controlSwitch)
        self.updateSwitchConstraints(superView: superView)
    }
    
    private func attachArrow(superView: UITableViewCell) {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "icArrowRight")
        superView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalTo(superView.snp.centerY)
            make.trailing.equalTo(superView.snp.trailing).inset(26)
        }
    }
    
    private func attachResetButton(superView: UITableViewCell) {
        superView.addSubview(self.resetButton)
        self.updateResetButtonConstraints(superView: superView)
    }
    
    private func attachAlertModalView() {
        self.alertModalView = AlertModalView.instantiate(alertLabelText: "정말 로그아웃 하시겠어요?\n일기를 다시 쓰려면 로그인해 주세요!", leftButtonTitle: "확인", rightButtonTitle: "취소")
        if let alertModalView = self.alertModalView {
            alertModalView.alertModalDelegate = self
            self.view.insertSubview(alertModalView, aboveSubview: self.view)
            self.updateAlertModalViewConstraints(view: alertModalView)
        }
    }
    
    private func attachVersionLabel() {
        self.settingTableView.addSubview(self.versionLabel)
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
    
    private func attachWithdrawalButton(superView: UITableViewCell) {
        superView.addSubview(self.withdrawalButton)
        self.updateWithdrawalButtonConstraints(superView: superView)
    }
    
    private func attachAlertModalView(alertLabelText: String) {
        self.alertModalView = AlertModalView.instantiate(alertLabelText: alertLabelText, leftButtonTitle: "확인", rightButtonTitle: "취소")
        if let alertModalView = self.alertModalView {
            alertModalView.alertModalDelegate = self
            self.view.insertSubview(alertModalView, aboveSubview: self.view)
            self.updateAlertModalViewConstraints(view: alertModalView)
        }
    }
    
    private func attachToastView(message: String) {
        self.toastView = ToastView.instantiate(message: message)
        guard let toastView = self.toastView else { return }
        toastView.alpha = 0.0
        self.view.insertSubview(toastView, aboveSubview: self.view)
        self.updateToastViewConstraints(view: toastView)
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
    
    private func detachToastView() {
        self.toastView?.removeFromSuperview()
    }
    
    private func detachSwitch() {
        self.controlSwitch.removeFromSuperview()
    }
    
    private func pushToInfoViewController() {
        let settingStoryboard = UIStoryboard(name: Constants.Name.settingStoryboard, bundle: nil)
        guard let infoViewController = settingStoryboard.instantiateViewController(identifier: Constants.Identifier.settingViewController) as? SettingViewController else { return }
        infoViewController.settingViewUsage = .info
        self.navigationController?.pushViewController(infoViewController, animated: true)
    }
    
    private func pushToLockViewController(usage: LockViewUsage) {
        let lockStoryboard = UIStoryboard(name: Constants.Name.lockStoryboard, bundle: nil)
        guard let lockViewController = lockStoryboard.instantiateViewController(identifier: Constants.Identifier.lockViewController) as? LockViewController else { return }
        lockViewController.lockViewUsage = usage
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
        let serviceTermStoryboard = UIStoryboard(name: Constants.Name.serviceTermStoryboard, bundle: nil)
        guard let serviceTermViewController = serviceTermStoryboard.instantiateViewController(identifier: Constants.Identifier.serviceTermViewController) as? ServiceTermViewController else {
            return
        }
        self.navigationController?.pushViewController(serviceTermViewController, animated: true)
        
    }
    
    private func pushToChangePasswordViewController() {
        let changePasswordStoryboard = UIStoryboard(name: Constants.Name.changePasswordStoryboard, bundle: nil)
        guard let changePasswordViewController = changePasswordStoryboard.instantiateViewController(identifier: Constants.Identifier.changePasswordViewController) as? ChangePasswordViewController else { return }
        self.navigationController?.pushViewController(changePasswordViewController, animated: true)
    }
    
    private func pushToTeamMomoViewController() {
        let teamStoryboard = UIStoryboard(name: Constants.Name.teamStoryboard, bundle: nil)
        guard let teamViewController = teamStoryboard.instantiateViewController(identifier: Constants.Identifier.teamViewController) as? TeamViewController else {
            return
        }
        self.navigationController?.pushViewController(teamViewController, animated: true)
    }
    
    private func pushToServiceEndViewController() {
        let storyboard = UIStoryboard(name: Constants.Name.serviceEndStoryboard, bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: Constants.Identifier.serviceEndViewController) as? ServiceEndViewController else { return }
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func openTeamMomoInstagram() {
        let username: String = "momo.__.diary"
        let appURL: URL = URL(string: "instagram://user?username=\(username)")!
        let application: UIApplication = UIApplication.shared
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            let webURL = URL(string: "https://instagram.com/\(username)")!
            application.open(webURL)
        }
    }
    
    private func popToLoginViewController() {
        if let loginViewController = self.navigationController?.viewControllers.filter({$0 is LoginViewController}).first as? LoginViewController {
            self.navigationController?.popToViewController(loginViewController, animated: true)
        } else {
            guard let homeViewController = self.navigationController?.viewControllers.filter({$0 is HomeViewController}).first as? HomeViewController else {
                return
            }
            homeViewController.isFromLogoutOrWithdrawal = true
            self.navigationController?.popToViewController(homeViewController, animated: true)
        }
    }
    
    private func popToSettingViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func popToHomeViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func touchNavigationButton(sender: UIBarButtonItem) {
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
    
    @objc func touchSwitch(sender: UISwitch) {
        if self.hasLock() {
            self.pushToLockViewController(usage: .switching)
        } else {
            self.pushToLockViewController(usage: .setting)
        }
    }
    
    @objc func touchResetButton(sender: UIButton) {
        self.pushToLockViewController(usage: .resetting)
    }
    
    @objc func touchWithDrawalButton(sender: UIButton) {
        self.settingAlertViewUsage = .withdrawal
        self.attachAlertModalView(alertLabelText: "정말 탈퇴 하시겠어요?\n작성된 일기를 다시 볼 수 없어요!")
    }
}

// MARK: - AlertModalViewDelegate

extension SettingViewController: AlertModalDelegate {
    func leftButtonTouchUp(button: UIButton) {
        switch self.settingAlertViewUsage {
        case .logout:
            self.deleteUserDefaults()
            self.popToLoginViewController()
        case .withdrawal:
            self.deleteUserWithAPI(completion: {
                self.deleteUserDefaults()
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
        
        if self.settingViewUsage == .setting && cellInfo.labelText == "일기 데이터 다운받기" {
            attachArrow(superView: cell)
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
    private func deleteUserWithAPI(completion: @escaping () -> Void) {
        UserService.shared.deleteUser { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    completion()
                }
            case .requestErr(let errorMessage):
                print(errorMessage)
            case .pathErr:
                print("pathErr in deleteUserWithAPI")
            case .serverErr:
                print("serverErr in deleteUserWithAPI")
            case .networkFail:
                print("networkFail in deleteUserWithAPI")
            }
        }
    }
}
