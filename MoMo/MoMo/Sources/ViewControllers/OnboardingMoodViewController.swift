//
//  OnboardingMoodViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/07.
//

import UIKit

struct ButtonShape {
    let cornerRadius: CGFloat = 12
    let shadowColor: CGColor = UIColor.init(named: "Blue5")!.cgColor
    let shadowOffset: CGSize = CGSize(width: 3, height: 3)
    let shadowOpacity: Float =  0.7
    let shadowRadius: CGFloat = 4.0
}

class OnboardingMoodViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var loveButton: UIButton!
    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var consoleButton: UIButton!
    @IBOutlet weak var angryButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    @IBOutlet weak var boredButton: UIButton!
    @IBOutlet weak var memoryButton: UIButton!
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var buttons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonShape = ButtonShape()
        
        self.buttons = [
            self.loveButton,
            self.happyButton,
            self.consoleButton,
            self.angryButton,
            self.sadButton,
            self.boredButton,
            self.memoryButton,
            self.dailyButton
        ]
        
        self.navigationControllerSetUp()
        
        self.buttonsRoundedUp(buttons: self.buttons, buttonShape: buttonShape)
        self.buttonsAddShadow(buttons: self.buttons, buttonShape: buttonShape)
        
    }
    
    func navigationControllerSetUp() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func buttonsRoundedUp(buttons: [UIButton], buttonShape: ButtonShape) {
        for button in buttons {
            button.layer.cornerRadius = buttonShape.cornerRadius
            button.clipsToBounds = true
        }
    }
    
    func buttonsAddShadow(buttons: [UIButton], buttonShape: ButtonShape) {
        for button in buttons {
            
            button.layer.shadowColor = buttonShape.shadowColor
            button.layer.shadowOpacity = buttonShape.shadowOpacity
            button.layer.shadowOffset = buttonShape.shadowOffset
            button.layer.shadowRadius = buttonShape.shadowRadius
            button.layer.masksToBounds = false
            
        }
    }
    
    @IBAction func loveButtonTouchUp(_ sender: UIButton) {
    }

    @IBAction func happyButtonTouchUp(_ sender: UIButton) {
    }
    
    @IBAction func consoleButtonTouchUp(_ sender: UIButton) {
    }
    
    @IBAction func angryButtonTouchUp(_ sender: UIButton) {
    }
    
    @IBAction func sadButtonTouchUp(_ sender: UIButton) {
    }
    
    @IBAction func boredButtonTouchUp(_ sender: UIButton) {
    }
    
    @IBAction func memoryButtonTouchUp(_ sender: UIButton) {
    }
    
    @IBAction func dailyButtonTouchUp(_ sender: UIButton) {
    }
}

extension OnboardingMoodViewController: UINavigationControllerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
