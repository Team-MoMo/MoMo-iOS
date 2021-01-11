//
//  TempViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/05.
//

import UIKit

class TempViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var text: String = ""
    var num: Int = 0
    
    var modalView: ListFilterModalViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalView = ListFilterModalViewController()
//        self.modalView?.modalPassDataDelegate = self

    }
    
    func showModal() {
//        let modalView = ListFilterModalViewController()
        modalView?.width = view.bounds.width
        modalView?.height = view.bounds.height
        modalView?.modalPresentationStyle = .custom
        modalView?.transitioningDelegate = self
        
        self.present(modalView!, animated: true, completion:nil)
    }
    
    @IBAction func modalButton(_ sender: Any) {
        showModal()
    }
    
    // self.present 했을때 실행되는 함수
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }

}

//extension TempViewController: ShitDelegate {
//    func sendData(num: Int, text: String) {
//        print(num)
//        print(text)
//    }
//    func fuck() {
//    }
//}
