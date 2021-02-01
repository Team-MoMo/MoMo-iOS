//
//  MoodStatViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/02/01.
//

import UIKit

class MoodStatViewController: UIViewController {
    
    // MARK: - Constants
    let multiplier: Float = 0.35
    
    // MARK: - Properties
    var maximum: CGFloat?
    var statViewMaximumHeight: CGFloat?
    var moodStatData: [Int] = [6,1,8,3,5,4,3,2]
    
    
    // MARK: -IBOutlets
    @IBOutlet var statNumLabel: Array<UILabel>?
    @IBOutlet var statViewHeight: Array<NSLayoutConstraint>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeMaximum()
        intializemStatViewMaximumHeight()
        intializeHeightConstraints()
        initializeLabels()
    }
    
    private func initializeMaximum() {
        guard let max = moodStatData.max() else {
            return
        }
        maximum = CGFloat(max)
    }
    private func intializemStatViewMaximumHeight() {
        statViewMaximumHeight = self.view.frame.height * CGFloat(multiplier)
    }
    
    private func intializeHeightConstraints() {
        guard let statHeights = statViewHeight, let viewHeight = statViewMaximumHeight, let max = maximum else {
            return
        }
        for constraint in 0..<statHeights.count {
            statHeights[constraint].constant = viewHeight * (CGFloat(moodStatData[constraint])/max)
        }
    }
    
    private func initializeLabels() {
        guard let labels = statNumLabel else {
            return
        }
        for num in 0..<labels.count {
            labels[num].text = "\(moodStatData[num])"
        }
    }
}
