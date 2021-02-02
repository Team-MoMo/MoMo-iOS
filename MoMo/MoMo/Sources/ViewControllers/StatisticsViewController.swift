//
//  StatisticsViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/29.
//

import UIKit

class StatisticsViewController: UIViewController {

    // MARK: - Constants:
    let moodText: String? = "감정"
    let depthText: String? = "깊이"
    
    var depthButtonSubLayer: CALayer? = nil
    var moodButtonSubLayer: CALayer? = nil
    
    // MARK: - IBOutlets
    @IBOutlet weak var depthButton: UIButton!
    @IBOutlet weak var moodButton: UIButton!
    @IBOutlet weak var statContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeNavigationItem()
        initializeSubLayer()
        initializeSubLayer()
        initializeButtonIsSelected()
        initializeIntialStatView()
    }

    // MARK: - Private Function
    
    private func initializeSubLayer() {
        let depthLayer = CALayer()
        depthLayer.frame = CGRect(x: 0,
                             y: moodButton.bounds.height-3,
                             width: moodButton.bounds.width,
                             height: 3)
        depthLayer.backgroundColor = UIColor.Blue1.cgColor
        depthButtonSubLayer = depthLayer
        let moodLayer = CALayer()
        moodLayer.frame = CGRect(x: 0,
                             y: moodButton.bounds.height-3,
                             width: moodButton.bounds.width,
                             height: 3)
        moodLayer.backgroundColor = UIColor.Blue1.cgColor
        moodButtonSubLayer = moodLayer
    }
    
    private func initializeButtonIsSelected() {
        depthButton.isSelected = false
        moodButton.isSelected = true
    }
    
    private func initializeIntialStatView() {
        changeMoodButtonSelectedInterface()
        addButtonSublayer()
        showMoodStatView()
    }
    
    private func initializeNavigationItem() {
        let backButton = UIBarButtonItem(image: Constants.Design.Image.btnBackBlack, style: .plain, target: self, action: #selector(touchBackButton))
        backButton.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "이 달의 통계"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.Black1]
        
    }
    
    private func removeChildView() {
        for viewController in children {
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }
    
    private func showMoodStatView() {
        guard let moodStatViewController = storyboard?.instantiateViewController(identifier: Constants.Identifier.moodStatViewController) as? MoodStatViewController else {
            return
        }
        addChild(moodStatViewController)
        moodStatViewController.view.frame = statContainerView.bounds
        statContainerView.addSubview(moodStatViewController.view)
    }
    
    private func showDepthStatView() {
        guard let depthStatViewController = storyboard?.instantiateViewController(identifier: Constants.Identifier.depthStatViewController) as? DepthStatViewController else {
            return
        }
        addChild(depthStatViewController)
        depthStatViewController.view.frame = statContainerView.bounds
        statContainerView.addSubview(depthStatViewController.view)
    }
    
    private func makeUnselectedButtonTitle(_ text: String) -> NSMutableAttributedString {
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .ultraLight),
                     NSAttributedString.Key.foregroundColor: UIColor.Black3List]
        let attrText = NSMutableAttributedString(string: text, attributes: attrs)
        return attrText
    }
    
    private func makeSelectedButtonTitle(_ text: String) -> NSMutableAttributedString {
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .semibold),
                     NSAttributedString.Key.foregroundColor: UIColor.Blue1]
        let attrText = NSMutableAttributedString(string: text, attributes: attrs)
        return attrText
    }
        
    private func changeMoodButtonSelectedInterface() {
        guard let depth = depthText, let mood = moodText else {
            return
        }
        moodButton.titleLabel?.attributedText = makeSelectedButtonTitle(mood)
        depthButton.titleLabel?.attributedText = makeUnselectedButtonTitle(depth)
    }
    
    private func changeDepthButtonSelectedInterface() {
        guard let depth = depthText, let mood = moodText else {
            return
        }
        moodButton.titleLabel?.attributedText = makeUnselectedButtonTitle(mood)
        depthButton.titleLabel?.attributedText = makeSelectedButtonTitle(depth)
    }
    
    private func addButtonSublayer() {
        guard let moodLayer = moodButtonSubLayer, let depthLayer = depthButtonSubLayer else {
            return
        }
        if moodButton.isSelected {
            moodButton.layer.addSublayer(moodLayer)
            depthLayer.removeFromSuperlayer()
        } else {
            depthButton.layer.addSublayer(depthLayer)
            moodLayer.removeFromSuperlayer()
        }
    }
    
    
    // MARK: - Selector Function
    @objc func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func touchMoodButton(_ sender: Any) {
        if !moodButton.isSelected {
            moodButton.isSelected.toggle()
            depthButton.isSelected.toggle()
            changeMoodButtonSelectedInterface()
            removeChildView()
            showMoodStatView()
            addButtonSublayer()
         
            
        }
    }
 
    @IBAction func touchDepthButton(_ sender: Any) {
        if moodButton.isSelected {
            moodButton.isSelected.toggle()
            depthButton.isSelected.toggle()
            changeDepthButtonSelectedInterface()
            removeChildView()
            showDepthStatView()
            addButtonSublayer()
           
        }
    }
}
