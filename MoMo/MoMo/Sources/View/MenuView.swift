//
//  MenuView.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/12.
//

import UIKit

protocol MenuViewDelegate: class {
    func dateMenuButtonTouchUp(sender: UITapGestureRecognizer)
    func depthMenuButtonTouchUp(sender: UITapGestureRecognizer)
    func diaryMenuButtonTouchUp(sender: UITapGestureRecognizer)
    func deleteMenubuttonTouchUp(sender: UITapGestureRecognizer)
}

class MenuView: UIView {
    
    @IBOutlet weak var dateMenuView: UIStackView!
    @IBOutlet weak var depthMenuView: UIStackView!
    @IBOutlet weak var diaryWriteMenuView: UIStackView!
    @IBOutlet weak var deleteMenuView: UIStackView!
    @IBOutlet weak var menuContainerView: UIView!
    weak var menuDelegate: MenuViewDelegate?
    
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
        let dateMenuViewTapGesture = UITapGestureRecognizer(target: menuView, action: #selector(self.touchDateMenuView(sender:)))
        let depthMenuViewTapGesture = UITapGestureRecognizer(target: menuView, action: #selector(self.touchDepthMenuView(sender:)))
        let diaryWriteMenuViewTapGesture = UITapGestureRecognizer(target: menuView, action: #selector(self.touchDiaryWriteMenuView(sender:)))
        let deleteMenuViewTapGesture = UITapGestureRecognizer(target: menuView, action: #selector(self.touchDeleteMenuView(sender:)))
        
        dateMenuViewTapGesture.numberOfTapsRequired = 1
        depthMenuViewTapGesture.numberOfTapsRequired = 1
        diaryWriteMenuViewTapGesture.numberOfTapsRequired = 1
        deleteMenuViewTapGesture.numberOfTapsRequired = 1
        
        menuView?.dateMenuView.addGestureRecognizer(dateMenuViewTapGesture)
        menuView?.depthMenuView.addGestureRecognizer(depthMenuViewTapGesture)
        menuView?.diaryWriteMenuView.addGestureRecognizer(diaryWriteMenuViewTapGesture)
        menuView?.deleteMenuView.addGestureRecognizer(deleteMenuViewTapGesture)
        
        menuView?.dateMenuView.isUserInteractionEnabled = true
        menuView?.diaryWriteMenuView.isUserInteractionEnabled = true
        menuView?.depthMenuView.isUserInteractionEnabled = true
        menuView?.deleteMenuView.isUserInteractionEnabled = true
        
        return menuView
    }
    
    @objc private func touchDateMenuView(sender: UITapGestureRecognizer) {
        self.menuDelegate?.dateMenuButtonTouchUp(sender: sender)
    }
    
    @objc private func touchDepthMenuView(sender: UITapGestureRecognizer) {
        self.menuDelegate?.depthMenuButtonTouchUp(sender: sender)
    }
    
    @objc private func touchDiaryWriteMenuView(sender: UITapGestureRecognizer) {
        self.menuDelegate?.diaryMenuButtonTouchUp(sender: sender)
    }
    
    @objc private func touchDeleteMenuView(sender: UITapGestureRecognizer) {
        self.menuDelegate?.deleteMenubuttonTouchUp(sender: sender)
    }
}
