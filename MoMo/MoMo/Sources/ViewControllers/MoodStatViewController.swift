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
    let emotion: [String] = ["사랑",
                             "행복",
                             "위로",
                             "화남",
                             "슬픔",
                             "우울",
                             "추억",
                             "일상"]
   
    // MARK: - Properties
    var maximum: CGFloat?
    var statViewMaximumHeight: CGFloat?
    var moodStatData: [Int] = [6, 1, 8, 3, 5, 4, 3, 2]
    
    // MARK: - IBOutlets
    @IBOutlet var statNumLabel: [UILabel]?
    @IBOutlet var emotionLabel: [UILabel]?
    @IBOutlet var statViewHeight: [NSLayoutConstraint]?
    @IBOutlet var statView: [UIView]?
    
    // MARK: - Override LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeStatBorderRadius()
        initializeMaximum()
        intializeStatViewMaximumHeight()
        intializeHeightConstraints()
        initializeLabels()
    }
    
    // MARK: - Private Function
    private func initializeStatBorderRadius() {
        guard let views = statView else {
            return
        }
        for idx in 0..<views.count {
            views[idx].layer.cornerRadius = 5
        }
    }
    
    private func initializeMaximum() {
        guard let max = moodStatData.max() else {
            return
        }
        maximum = CGFloat(max)
    }
    
    private func intializeStatViewMaximumHeight() {
        statViewMaximumHeight = self.view.frame.height * CGFloat(multiplier)
    }
    
    private func intializeHeightConstraints() {
        guard let statHeights = statViewHeight, let viewHeight = statViewMaximumHeight, let max = maximum, let views = statView else {
            return
        }
        for idx in 0..<statHeights.count {
            if max == 0 {
                statHeights[idx].constant = 0 
            } else {
                statHeights[idx].constant = viewHeight * (CGFloat(moodStatData[idx])/max)
            }
            views[idx].layoutIfNeeded()
        }
    }
    
    private func initializeLabels() {
        guard let labels = statNumLabel, let unwrappedEmotionLabel = emotionLabel else {
            return
        }
        for num in 0..<labels.count {
            labels[num].attributedText = "\(moodStatData[num])".wordTextSpacing(textSpacing: -0.6, lineSpacing: 4, center: true, truncated: false)
            unwrappedEmotionLabel[num].attributedText = emotion[num].textSpacing()
        }
    }
}
