//
//  TempViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/05.
//

import UIKit

class TempViewController: UIViewController, UIViewControllerTransitioningDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func showModal() {
        let modalView = ListFilterModalViewController()
        modalView.width = view.bounds.width
        modalView.height = view.bounds.height
        modalView.modalPresentationStyle = .custom
        modalView.transitioningDelegate = self
        self.present(modalView, animated: true, completion: nil)
        print(1)
        
    }
    
    @IBAction func modalButton(_ sender: Any) {
        showModal()
    }
    
    // self.present 했을때 실행되는 함수
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }

}
