//
//  ModalPresentationController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/05.
//

import UIKit

class ModalPresentationController: UIPresentationController {
    let blurEffectView: UIVisualEffectView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var check: Bool = false
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(presentedViewController: presentedViewController, presenting: presentedViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(dismissController))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin:CGPoint(x:0, y: self.containerView!.frame.height*0.08), size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height * 0.92))
    }
    
    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.containerView!.addSubview(blurEffectView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { UIViewControllerTransitionCoordinatorContext in self.blurEffectView.alpha = 0.7}, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { UIViewControllerTransitionCoordinatorContext in self.blurEffectView.alpha = 0}, completion: { UIViewControllerTransitionCoordinatorContext in self.blurEffectView.removeFromSuperview()})
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        if check{
            presentedView?.frame = frameOfPresentedViewInContainerView
            check.toggle()
        } else {
            presentedView?.frame = CGRect(origin:CGPoint(x:0, y: self.containerView!.frame.height*0.27), size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height * 0.73))
            check.toggle()
        }
       
        blurEffectView.frame = containerView!.bounds
    }
    
    @objc func dismissController(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}
