//
//  ServiceTermViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/02/17.
//

import UIKit

class ServiceTermViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var navigationItemTitleLabel: UILabel = {
        let label = UILabel()
        guard let font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16) else {
            return UILabel()
        }
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.Black2Nav,
            NSAttributedString.Key.kern: -0.6]
        label.attributedText = NSAttributedString(string: "서비스 이용 약관", attributes: attributes)
        label.sizeToFit()
        return label
    }()
    
    // MARK: - Constants
    
    let serviceTermText =
    """
    제 1장 총칙

    제 1조 (목적)

    이 약관은 “MOMO”(이하 “회사”라 합니다)가 제공하는 “MOMO 앱 서비스”(이하 ‘서비스’라 합니다)를 회사와 이용계약을 체결한 ‘고객’이 이용함에 있어 필요한 회사와 고객의 권리 및 의무, 기타 제반 사항을 정함을 목적으로 합니다.

    제 2조 (약관 외 준칙)

    이 약관에 명시되지 않은 사항에 대해서는 위치 정보의 보호 및 이용 등에 관한 법률, 전기통신사업법, 정보통신망 이용 촉진및 보호 등에 관한 법률 등 관계법령 및 회사가 정한 서비스의 세부이용지침 등의 규정에 따릅니다.

    제 2장 서비스의 이용

    제 3조 (가입자격)

    ① 서비스에 가입할 수 있는 자는 Application 이 설치가능한 모든 사람 입니다.

    제 4조 (서비스 가입)

    ① “Application 관리자”가 정한 본 약관에 고객이 동의하면 서비스 가입의 효력이 발생합니다.

    ② “Application 관리자”는 다음 각 호의 고객 가입신청에 대해서는 이를 승낙하지 아니할 수 있습니다.

    1. 고객 등록 사항을 누락하거나 오기하여 신청하는 경우

    2. 공공질서 또는 미풍양속을 저해하거나 저해할 목적으로 신청한 경우

    3. 기타 회사가 정한 이용신청 요건이 충족되지 않았을 경우

    제 5조 (서비스의 탈퇴)

    서비스 탈퇴를 희망하는 고객은 “Application 담당자”가 정한 소정의 절차(설정메뉴의 탈퇴)를 통해 서비스 해지를 신청할 수 있습니다.

    제 6조 (서비스의 수준)

    ① 서비스의 이용은 연중무휴 1일 24시간을 원칙으로 합니다. 단, 회사의 업무상이나 기술상의 이유로 서비스가 일시 중지될 수 있으며, 운영상의 목적으로 회사가 정한 기간에는 서비스가 일시 중지될 수 있습니다. 이러한 경우 회사는 사전 또는 사후에 이를 공지합니다.

    ② 위치정보는 관련 기술의 발전에 따라 오차가 발생할 수 있습니다.

    제 7조 (서비스 이용의 제한 및 정지)

    회사는 고객이 다음 각 호에 해당하는 경우 사전 통지 없이 고객의 서비스 이용을 제한 또는 정지하거나 직권 해지를 할 수 있습니다.

    1. 타인의 서비스 이용을 방해하거나 타인의 개인정보를 도용한 경우

    2. 서비스를 이용하여 법령, 공공질서, 미풍양속 등에 반하는 행위를 한 경우

    제 8조 (서비스의 변경 및 중지)

    ① 회사는 다음 각 호의 1에 해당하는 경우 고객에게 서비스의 전부 또는 일부를 제한, 변경하거나 중지할 수 있습니다.

    1. 서비스용 설비의 보수 등 공사로 인한 부득이한 경우

    2. 정전, 제반 설비의 장애 또는 이용량의 폭주 등으로 정상적인 서비스 이용에 지장이 있는 경우

    3. 서비스 제휴업체와의 계약 종료 등과 같은 회사의 제반 사정 또는 법률상의 장애 등으로 서비스를 유지할 수 없는 경우

    4.기타 천재지변, 국가비상사태 등 불가항력적 사유가 있는 경우

    ② 제1항에 의한 서비스 중단의 경우에는 회사는 인터넷 등에 공지하거나 고객에게 통지합니다. 다만, 회사가 통제할 수 없는 사유로 인한 서비스의 중단 (운영자의 고의, 과실이 없는 디스크 장애, 시스템 다운 등)으로 인하여 사전 통지가 불가능한 경우에는 사후에 통지합니다.

    제 5장 기타

    제 19조 (회사의 연락처)

    회사의 상호 다음과 같습니다.

    1. 상호: “MOMO”

    1. 이메일 주소: momoisdiary@gmail.com

    제 20조 (양도금지)

    고객 및 회사는 고객의 서비스 가입에 따른 본 약관상의 지위 또는 권리,의무의 전부 또는 일부를 제3자에게 양도, 위임하거나 담보제공 등의 목적으로 처분할 수 없습니다.

    제 21조 (손해배상)

    ① 고객의 고의나 과실에 의해 이 약관의 규정을 위반함으로 인하여 회사에 손해가 발생하게 되는 경우, 이 약관을 위반한 고객은 회사에 발생하는 모든 손해를 배상하여야 합니다.

    ② 고객이 서비스를 이용함에 있어 행한 불법행위나 고객의 고의나 과실에 의해 이 약관 위반행위로 인하여 회사가 당해 고객 이외의 제3자로부터 손해배상청구 또는 소송을 비롯한 각종 이의제기를 받는 경우 당해 고객은 그로 인하여 회사에 발생한 손해를 배상하여야 합니다.

    ③ 회사가 위치정보의 보호 및 이용 등에 관한 법률 제 15조 내지 제26조의 규정을 위반한 행위 혹은 회사가 제공하는 서비스로 인하여 고객에게 손해가 발생한 경우, 회사가 고의 또는 과실 없음을 입증하지 아니하면, 고객의 손해에 대하여 책임을 부담합니다.

    제 22조 (면책사항)

    ① 회사는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이 면제됩니다.

    ② 회사는 고객의 귀책사유로 인한 서비스의 이용장애에 대하여 책임을 지지 않습니다.

    ③ 회사는 고객이 서비스를 이용하여 기대하는 수익을 상실한 것에 대하여 책임을 지지 않으며, 그 밖에 서비스를 통하여 얻은 자료로 인한 손해 등에 대하여도 책임을 지지 않습니다.

    ④ 회사에서 제공하는 서비스 및 서비스를 이용하여 얻은 정보에 대한 최종판단은 고객이 직접 하여야 하고, 그에 따른 책임은 전적으로 고객 자신에게 있으며, 회사는 그로 인하여 발생하는 손해에 대해서 책임을 부담하지 않습니다.

    ⑤ 회사의 업무상 또는 기술상의 장애로 인하여 서비스를 개시하지 못하는 경우 회사는 인터넷 홈페이지 등에 이를 공지하거나 E-mail 등의 방법으로 고객에게 통지합니다. 단, 회사가 통제할 수 없는 사유로 인하여 사전 공지가 불가능한 경우에는 사후에 공지합니다.

    제 23조 (분쟁의 해결 및 관할법원)

    ① 서비스 이용과 관련하여 회사와 고객 사이에 분쟁이 발생한 경우, 회사와 고객은 분쟁의 해결을 위해 성실히 협의합니다.

    ② 제1항의 협의에서도 분쟁이 해결되지 않을 경우 양 당사자는 정보통신망 이용촉진 및 정보보호 등에 관한 법률 제33조의 규정에 의한 개인정보분쟁조정위원회에 분쟁조정을 신청할 수 있습니다.
    """
    
    // MARK: - IBoutlets
    @IBOutlet weak var serviceTermTextView: UITextView!
    
    // MARK: - Override ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextViewText()
        initializeNavigationItem()
        initializeTextView()
    }
    
    private func initializeTextView() {
        serviceTermTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }
    
    private func initializeTextViewText() {
        serviceTermTextView.attributedText = serviceTermText.textSpacing(lineSpacing: 4)
    }
    
    private func initializeNavigationItem() {
        let backButton = UIBarButtonItem(image: Constants.Design.Image.btnBackBlack, style: .plain, target: self, action: #selector(dismissServiceTermViewController))
        backButton.tintColor = UIColor.Black1
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.titleView = navigationItemTitleLabel
    }
    
    @objc func dismissServiceTermViewController() {
        self.navigationController?.popViewController(animated: true)
    }

}
