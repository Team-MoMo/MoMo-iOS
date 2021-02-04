//
//  PersonalTermViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/02/04.
//

import UIKit

class PersonalTermViewController: UIViewController {

    // MARK: - Constants
    let personInfoText = """
    1. 개인정보의 처리 목적 (‘https://blog.naver.com/heey1792’이하 ‘MOMO’) 은(는) 다음의 목적을 위하여 개인정보를 처리하고 있으며, 다음의 목적 이외의 용도로는 이용하지 않습니다.

    - 고객 가입의사 확인, 고객에 대한 서비스 제공에 따른 본인 식별.인증, 회원자격 유지.관리, 물품 또는 서비스 공급에 따른 금액 결제, 물품 또는 서비스의 공급.배송 등

    2. 개인정보의 처리 및 보유 기간

    ① (‘https://blog.naver.com/heey1792’이하 ‘MOMO’) 은(는) 정보주체로부터 개인정보를 수집할 때 동의 받은 개인정보 보유․이용기간 또는 법령에 따른 개인정보 보유․이용기간 내에서 개인정보를 처리․보유합니다.

    ② 구체적인 개인정보 처리 및 보유 기간은 다음과 같습니다.

    ☞ 아래 예시를 참고하여 개인정보 처리업무와 개인정보 처리업무에 대한 보유기간 및 관련 법령, 근거 등을 기재합니다.

    (예시)- 고객 가입 및 관리 : 서비스 이용계약 또는 회원가입 해지시까지, 다만 채권․채무관계 잔존시에는 해당 채권․채무관계 정산시까지

    - 전자상거래에서의 계약․청약철회, 대금결제, 재화 등 공급기록 : 5년
    3. 정보주체와 법정대리인의 권리·의무 및 그 행사방법 이용자는 개인정보주체로써 다음과 같은 권리를 행사할 수 있습니다.

    ① 정보주체는 MOMO(‘https://blog.naver.com/heey1792’이하 ‘MOMO) 에 대해 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다.

    1. 개인정보 열람요구

    2. 오류 등이 있을 경우 정정 요구

    3. 삭제요구

    4. 처리정지 요구



    4. 처리하는 개인정보의 항목 작성

    ① ('https://blog.naver.com/heey1792'이하 'MOMO')은(는) 다음의 개인정보 항목을 처리하고 있습니다.



    5. 개인정보의 파기('MOMO')은(는) 원칙적으로 개인정보 처리목적이 달성된 경우에는 지체없이 해당 개인정보를 파기합니다. 파기의 절차, 기한 및 방법은 다음과 같습니다.

    -파기절차
    이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서류) 내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다. 이 때, DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.

    -파기기한
    이용자의 개인정보는 개인정보의 보유기간이 경과된 경우에는 보유기간의 종료일로부터 5일 이내에, 개인정보의 처리 목적 달성, 해당 서비스의 폐지, 사업의 종료 등 그 개인정보가 불필요하게 되었을 때에는 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 5일 이내에 그 개인정보를 파기합니다.



    6. 개인정보 자동 수집 장치의 설치•운영 및 거부에 관한 사항

    MOMO 은 정보주체의 이용정보를 저장하고 수시로 불러오는 ‘쿠키’를 사용하지 않습니다.

    7. 개인정보 보호책임자 작성

    ① MOMO(‘https://blog.naver.com/heey1792’이하 ‘MOMO) 은(는) 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.

    ▶ 개인정보 보호책임자
    성명 :김희영
    직책 :매니저
    직급 :매니저
    연락처 :01052356510, momoisdiary@gmail.com,
    ※ 개인정보 보호 담당부서로 연결됩니다.

    ▶ 개인정보 보호 담당부서
    부서명 :
    담당자 :
    연락처 :, ,
    ② 정보주체께서는 MOMO(‘https://blog.naver.com/heey1792’이하 ‘MOMO) 의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. MOMO(‘https://blog.naver.com/heey1792’이하 ‘MOMO) 은(는) 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.

    8. 개인정보 처리방침 변경

    ①이 개인정보처리방침은 시행일로부터 적용되며, 법령 및 방침에 따른 변경내용의 추가, 삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 공지사항을 통하여 고지할 것입니다.



    9. 개인정보의 안전성 확보 조치 ('MOMO')은(는) 개인정보보호법 제29조에 따라 다음과 같이 안전성 확보에 필요한 기술적/관리적 및 물리적 조치를 하고 있습니다.

    1. 해킹 등에 대비한 기술적 대책
    <MOMO>('MOMO')은 해킹이나 컴퓨터 바이러스 등에 의한 개인정보 유출 및 훼손을 막기 위하여 보안프로그램을 설치하고 주기적인 갱신·점검을 하며 외부로부터 접근이 통제된 구역에 시스템을 설치하고 기술적/물리적으로 감시 및 차단하고 있습니다.

    2. 개인정보의 암호화
    이용자의 개인정보는 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는 등의 별도 보안기능을 사용하고 있습니다.

    3. 개인정보에 대한 접근 제한
    개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여,변경,말소를 통하여 개인정보에 대한 접근통제를 위하여 필요한 조치를 하고 있으며 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있습니다.
    """
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var personalInfoTextView: UITextView!
    
    //MARK: - Override ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextView()
        initializeNavigationItem()
        print(personalInfoTextView.contentSize)
        print(personalInfoTextView.contentOffset)
    }
    
    private func initializeTextView() {
        personalInfoTextView.attributedText = personInfoText.wordSpacing(-0.6)
    }
    
    private func initializeNavigationItem() {
        let backButton = UIBarButtonItem(image: Constants.Design.Image.btnBackBlack, style: .plain, target: self, action: #selector(dismissPersonalInfo))
        backButton.tintColor = UIColor.Black1
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "개인정보 이용 약관"
    }
    
    @objc func dismissPersonalInfo() {
        self.navigationController?.popViewController(animated: true)
    }

}
