//
//  OnboardingWrite1ViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/07.
//

import UIKit

class OnboardingWriteViewController: UIViewController {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var sentenceLabel: UILabel!
    
    @IBOutlet weak var onboardingCircleSmall: UIImageView!
    @IBOutlet weak var onboardingCircleBig: UIImageView!
    
    let defaultBookTitle: String = "책제목"
    let defaultPublisher: String = "출판사이름"
    var selectedSentence: Sentence?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        authorLabel.text = selectedSentence?.author
        bookTitleLabel.text = "<\(self.selectedSentence?.bookTitle ?? self.defaultBookTitle)>"
        publisherLabel.text = "(\(self.selectedSentence?.publisher?.first! ?? self.defaultPublisher.first!))"
        sentenceLabel.text = selectedSentence?.sentence
    }
    
//    func getFormattedPublihser(publisher: String) -> String {
//
//    }
    
}
