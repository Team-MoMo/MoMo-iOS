//
//  SplashViewController.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/13.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {

    @IBOutlet weak var momoSplashAnimationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startMomoSplashAnimation()
    }
    
    func startMomoSplashAnimation() {
        self.momoSplashAnimationView.contentMode = .scaleAspectFit
        self.momoSplashAnimationView.loopMode = .loop
        self.momoSplashAnimationView.animationSpeed = 1
        self.momoSplashAnimationView.play()
    }
}
