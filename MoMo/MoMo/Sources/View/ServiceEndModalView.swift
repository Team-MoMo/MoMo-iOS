//
//  ServiceEndModalView.swift
//  MoMo
//
//  Created by Haeseok Lee on 2023/02/12.
//

import UIKit

final class ServiceEndModalView: UIView {
    
    @IBOutlet weak var containerView: UIStackView!
    
    @IBOutlet private weak var goodbyeImageView: UIImageView! {
        willSet {
            newValue.image = UIImage.init(named: "good_bye_momo")
        }
    }
    
    @IBOutlet private weak var titleLabel: UILabel! {
        willSet {
            newValue.text = "모모 서비스 종료 안내"
            newValue.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 600))
            newValue.textColor = .black
        }
    }
    
    @IBOutlet private weak var descriptionLabel: UILabel! {
        willSet {
            newValue.attributedText = "안녕하세요. MOMO를 만든 Team MOMO입니다.\n내부적인 사정으로 인해 아쉽게도 서비스 종료 소식을\n알려드리게 되었습니다.".textSpacing()
            newValue.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            newValue.textColor = .black
        }
    }
    
    @IBOutlet private weak var goodbyeDateContainerView: UIView! {
        willSet {
            newValue.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.7)
            newValue.layer.cornerRadius = 8
            newValue.layer.cornerCurve = .continuous
        }
    }
    
    @IBOutlet private weak var goobbyeDateLabel: UILabel! {
        willSet {
            newValue.attributedText = "서비스 종료일 : 2023년 5월 31일".textSpacing()
            newValue.textColor = UIColor.BlueModalAble
            newValue.font = UIFont.systemFont(ofSize: 12, weight: .init(rawValue: 600))
        }
    }
    
    @IBOutlet private weak var descriptionLabel2: UILabel! {
        willSet {
            newValue.attributedText = "그 동안 MOMO 다이어리에 작성하신 일기는 다운로드 링크를 통해 csv 파일로 다운 받으실 수 있습니다.\nMOMO 다이어리를 사용해 주셔서 진심으로 감사합니다!".textSpacing()
            newValue.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            newValue.textColor = .black
        }
    }
    
    @IBOutlet private weak var downloadButton: UIButton! {
        willSet {
            newValue.layer.cornerRadius = 25
            newValue.layer.cornerCurve = .continuous
            newValue.backgroundColor = UIColor.BlueModalAble
            newValue.setAttributedTitle("일기 다운받기".textSpacing(), for: .normal)
            newValue.setTitleColor(.white, for: .normal)
            newValue.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .init(rawValue: 600))
        }
    }
    
    @IBOutlet private weak var doNotSeeAgainFor3DaysConfirmButton: UIButton! {
        willSet {
            newValue.setTitle("3일 간 다시 보지 않기", for: .normal)
            newValue.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
    }
    
    @IBOutlet private weak var doNotSeeAgainConfirmButton: UIButton! {
        willSet {
            newValue.setTitle("닫기", for: .normal)
            newValue.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
    }
    
    var didTapDownloadButtonHandler: ((UIButton) -> Void)?
    
    var didTapDoNotSeeAgainFor3DaysConfirmButtonHandler: ((UIButton) -> Void)?
    
    var didTapDoNotSeeAgainConfirmButton: ((UIButton) -> Void)?
}

private extension ServiceEndModalView {
    
    @IBAction func didTapDownloadButton(sender: UIButton) {
        didTapDownloadButtonHandler?(sender)
    }
    
    @IBAction func didTapDoNotSeeAgainFor3DaysConfirmButton(sender: UIButton) {
        didTapDoNotSeeAgainFor3DaysConfirmButtonHandler?(sender)
    }
    
    @IBAction func didTapDoNotSeeAgainConfirmButton(sender: UIButton) {
        didTapDoNotSeeAgainConfirmButton?(sender)
    }
}
