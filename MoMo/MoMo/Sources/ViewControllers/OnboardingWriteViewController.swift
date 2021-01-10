//
//  OnboardingWrite1ViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/07.
//

import UIKit
import CLTypingLabel

class OnboardingWriteViewController: UIViewController {

    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var typingLabel: CLTypingLabel!
    @IBOutlet weak var typingCursorLabel: UILabel!
    
    @IBOutlet weak var featherImage: UIImageView!
    @IBOutlet weak var onboardingCircleSmallImage: UIImageView!
    @IBOutlet weak var onboardingCircleBigImage: UIImageView!
    
    @IBOutlet weak var sentenceInfoStackView: UIStackView!
    
    // MARK: - Properties
    
    let defaultBookTitle: String = "책제목"
    let defaultPublisher: String = "출판사이름"
    let defaultTypingLabelText: String = "새로운 인연이 기대되는 하루였다. "
    var selectedSentence: Sentence?
    var sentenceWasShown: Bool = false
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTypingLabel()
        self.typingLabel.pauseTyping()
        self.hideTypingCursorLabel()
        self.typingLabel.onTypingAnimationFinished = showTypingCursorBlinkWithAnimation
        self.setSentenceLabel()
        self.hideFeatherImage()
        self.hideSentenceLabel()
        self.hideTypingLabel()
    }
    
    func pushToDeepViewController(finished: Bool) {
        
        guard let deepViewController = self.storyboard?.instantiateViewController(identifier: Constants.Identifier.deepViewController) as? DeepViewController else { return }
        
        self.navigationController?.pushViewController(deepViewController, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showOnboardingCircleSmallImage()
        self.showOnboardingCircleBigImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if sentenceWasShown {
            self.moveSentenceLabelAndFeatherImage()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showOnboardingCircleSmallImage()
        self.showOnboardingCircleBigImage()
        self.showSentenceLabelAndFeatherImageWithAnimation(
            completion: moveSentenceLabelAndFeatherImageWithAnimation
        )
        self.moveOnboardingCirclesWithAnimation()
    }
}

// MARK: - Functions

extension OnboardingWriteViewController {
    
    func setSentenceLabel() {
        self.authorLabel.text = self.selectedSentence?.author
        self.bookTitleLabel.text = "<\(self.selectedSentence?.bookTitle ?? self.defaultBookTitle)>"
        self.publisherLabel.text = "(\(self.selectedSentence?.publisher?.first! ?? self.defaultPublisher.first!))"
        self.sentenceLabel.text = self.selectedSentence?.sentence
    }
    
    func setTypingLabel() {
        self.typingLabel.text = self.defaultTypingLabelText
    }
    
    func hideFeatherImage() {
        self.featherImage.isHidden = true
    }
    
    func hideSentenceLabel() {
        self.authorLabel.isHidden = true
        self.bookTitleLabel.isHidden = true
        self.publisherLabel.isHidden = true
        self.sentenceLabel.isHidden = true
    }
    
    func hideTypingLabel() {
        self.typingLabel.isHidden = true
    }
    
    func hideTypingCursorLabel() {
        self.typingCursorLabel.isHidden = true
    }
    
    func hideOnboardingCircleSmallImage() {
        self.onboardingCircleSmallImage.isHidden = true
    }
    
    func hideOnboardingCircleBigImage() {
        self.onboardingCircleBigImage.isHidden = true
    }
    
    func showFeatherImage() {
        self.featherImage.isHidden = false
    }
    
    func showSentenceLabel() {
        self.authorLabel.isHidden = false
        self.bookTitleLabel.isHidden = false
        self.publisherLabel.isHidden = false
        self.sentenceLabel.isHidden = false
    }
    
    func showTypingLabel() {
        self.typingLabel.isHidden = false
    }
    
    func showTypingCursorLabel() {
        self.typingCursorLabel.isHidden = false
    }
    
    func showOnboardingCircleSmallImage() {
        self.onboardingCircleSmallImage.isHidden = false
    }
    
    func showOnboardingCircleBigImage() {
        self.onboardingCircleBigImage.isHidden = false
    }
    
    func showSentenceLabelAndFeatherImageWithAnimation(completion: @escaping () -> Void) {
        UIView.transition(
            with: self.view,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
                self.showFeatherImage()
                self.showSentenceLabel()
            },
            completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(2500), execute: { () -> Void in
                    completion()
                })
                
            }
        )
    }
    
    func showTypingCursorBlinkWithAnimation () {
        self.typingCursorLabel.startBlink()
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + .milliseconds(1500),
            execute: { () -> Void in
                UIView.animate(
                    withDuration: 0.1,
                    delay: 0,
                    animations: {
                        self.typingCursorLabel.stopBlink()
                    },
                    completion: self.pushToDeepViewController(finished:)
                )
            }
        )
    }
    
    func moveOnboardingCirclesWithAnimation() {
        
        let movedown = CGAffineTransform(translationX: 0, y: 50)
        let moveup = CGAffineTransform(translationX: 0, y: -100)
        
        UIView.animate(
            withDuration: 2.0,
            delay: 0.5,
            animations: {
                self.onboardingCircleSmallImage.transform = movedown
                self.onboardingCircleBigImage.transform = moveup
            },
            completion: nil
        )
    }
    
    func moveSentenceLabelAndFeatherImageWithAnimation() {
        
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            animations: {
                self.moveSentenceLabelAndFeatherImage()
                self.sentenceWasShown = true
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                
                self.showTypingCursorLabel()
                self.showTypingLabel()
                self.typingLabel.continueTyping()
            }
            
        )
    }
    
    func moveSentenceLabelAndFeatherImage() {
        let infoLabelXpos = self.infoLabel.frame.origin.x
        let infoLabelYpos = self.infoLabel.frame.origin.y
        let infoLabelHeight = self.infoLabel.frame.size.height
        
        self.featherImage.frame.origin.x = infoLabelXpos
        self.featherImage.frame.origin.y = infoLabelYpos + infoLabelHeight + 74
        
        self.sentenceInfoStackView.frame.origin.x = infoLabelXpos
        self.sentenceInfoStackView.frame.origin.y = infoLabelYpos + infoLabelHeight + 116
        
        self.sentenceLabel.frame.origin.x = infoLabelXpos
        self.sentenceLabel.frame.origin.y = infoLabelYpos + infoLabelHeight + 147
        
        self.sentenceLabel.textColor = UIColor.Black4
        self.sentenceLabel.font = self.sentenceLabel.font.withSize(14)
        self.sentenceLabel.textAlignment = .left
    }
    
    func pushToDeepViewController(finished: Bool) {
        
        guard let deepViewController = self.storyboard?.instantiateViewController(identifier: Constants.Identifier.deepViewController) as? DeepViewController else { return }
        
        self.navigationController?.pushViewController(deepViewController, animated: true)
        
    }
}
