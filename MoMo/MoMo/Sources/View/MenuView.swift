//
//  MenuView.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/12.
//

import UIKit

protocol MenuDelegate: class {
    func dateMenuButtonTouchUp(sender: UIButton)
    func depthMenuButtonTouchUp(sender: UIButton)
    func diaryMenuButtonTouchUp(sender: UIButton)
    func deleteMenubuttonTouchUp(sender: UIButton)
}

class MenuView: UIView {
    
    @IBOutlet weak var menuContainerView: UIView!
    weak var menuDelegate: MenuDelegate?
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Functions
    
    static func instantiate() -> MenuView? {
        
        let menuView: MenuView? = initFromNib()
        
        return menuView
    }
    @IBAction func dateMenuButtonTouchUp(_ sender: UIButton) {
        self.menuDelegate?.dateMenuButtonTouchUp(sender: sender)
    }
    @IBAction func depthMenuButtonTouchUp(_ sender: UIButton) {
        self.menuDelegate?.depthMenuButtonTouchUp(sender: sender)
    }
    @IBAction func diaryMenuButtonTouchUp(_ sender: UIButton) {
        self.menuDelegate?.diaryMenuButtonTouchUp(sender: sender)
    }
    @IBAction func deleteMenubuttonTouchUp(_ sender: UIButton) {
        self.menuDelegate?.deleteMenubuttonTouchUp(sender: sender)
    }
}
