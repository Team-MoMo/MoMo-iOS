//
//  ServiceEndViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2023/02/12.
//

import UIKit

final class ServiceEndViewController: UIViewController {
    
    
    @IBOutlet private weak var goodbyeDateContainerView: UIView! {
        willSet {
            newValue.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.7)
            newValue.layer.cornerRadius = 8
            newValue.layer.cornerCurve = .continuous
        }
    }
    
    @IBOutlet weak var emailTextContainerView: UIView! {
        willSet {
            newValue.layer.borderWidth = 1
            newValue.layer.borderColor = UIColor.Black5Publish.cgColor
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var downloadButton: UIButton! {
        willSet {
            newValue.layer.cornerRadius = 25
            newValue.layer.cornerCurve = .continuous
            newValue.backgroundColor = UIColor.BlueModalAble
            newValue.setAttributedTitle("링크 받기".textSpacing(), for: .normal)
            newValue.setTitleColor(.white, for: .normal)
            newValue.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .init(rawValue: 600))
        }
    }
    
    private lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: Constants.Design.Image.btnBackWhite, style: .plain, target: self, action: #selector(didTapBackButton))
        button.tintColor = UIColor.Black1
        return button
    }()
    
    private var toastView: ToastView?
    
    private var email: String?
    
    private var isRequesting: Bool = false
    
    private let serviceEndUseCase: ServiceEndUseCase = ServiceEndUseCaseImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.title = "일기 다운받기"
        emailTextField.delegate = self
    }
}

extension ServiceEndViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        email = textField.text
    }
}

private extension ServiceEndViewController {
    
    @IBAction func didTapDownloadButton(sender: UIButton) {
        guard let email = email, !email.isEmpty else {
            showToast(message: "이메일을 입력해주세요.")
            return
        }
        
        if isRequesting {
            showToast(message: "링크를 발송중입니다.")
            return
        }
        
        if serviceEndUseCase.shouldRequestDownloadLink {
            isRequesting = true
            serviceEndUseCase.requestDownloadLink() { [weak self] in
                self?.showToast(message: "링크가 발송되었습니다. 메일을 확인해주세요.")
                self?.isRequesting = false
            }
        } else {
            showToast(message: "메일은 하루에 \(serviceEndUseCase.maximumDownloadLinkRequestCountPerDay)번만 받으실 수 있습니다.")
        }
    }
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func showToast(message: String) {
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }), toastView == nil else { return }
        let toastView: ToastView = ToastView.instantiate(message: message)!
        toastView.translatesAutoresizingMaskIntoConstraints = false
        self.toastView = toastView
        
        keyWindow.addSubview(toastView)
        NSLayoutConstraint.activate([
            toastView.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor),
            toastView.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor),
            toastView.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor)
        ])
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self, weak toastView] in
            if toastView?.superview != nil {
                toastView?.removeFromSuperview()
                self?.toastView = nil
            }
        }
    }
}
