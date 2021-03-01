//
//  DepthStatViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/29.
//

import UIKit

class DepthStatViewController: UIViewController {
    
    // MARK: - Constants
    let multiplier: Float = 0.38
    let gradientColor: [CGColor]? = [UIColor.Gradient1.cgColor,
                                     UIColor.Gradient2.cgColor,
                                     UIColor.Gradient3.cgColor,
                                     UIColor.Gradient4.cgColor,
                                     UIColor.Gradient5.cgColor,
                                     UIColor.Gradient6.cgColor,
                                     UIColor.Gradient7.cgColor,
                                     UIColor.Gradient8.cgColor]
    
    let objetImage: [UIImage?] = [Constants.Design.Image.graph2M,
                                 Constants.Design.Image.graph30M,
                                 Constants.Design.Image.graph100M,
                                 Constants.Design.Image.graph300M,
                                 Constants.Design.Image.graph700M,
                                 Constants.Design.Image.graph1005M,
                                 Constants.Design.Image.graphUnder]
    
    let depth: [String] = ["2m",
                           "30m",
                           "100m",
                           "300m",
                           "700m",
                           "1,005m",
                           "심해"]
    
    // MARK: - Properties
    var maximum: CGFloat?
    var statViewMaximumHeight: CGFloat?
    var depthStatData: [Int] = [6, 1, 8, 3, 5, 4, 3]
    
    // MARK: - IBOutlets
    
    @IBOutlet var statNumLabel: [UILabel]?
    @IBOutlet var depthLabel: [UILabel]?
    @IBOutlet var statViewHeight: [NSLayoutConstraint]?
    @IBOutlet var statView: [UIView]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeStatBorderRadius()
        initializeMaximum()
        intializeStatViewMaximumHeight()
        intializeHeightConstraints()
        initializeLabels()
        initializeStatViewColor()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Override LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeStatViewColor()
        attachObjet()
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
        guard let max = depthStatData.max() else {
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
                statHeights[idx].constant = viewHeight * (CGFloat(depthStatData[idx])/max)
            }
            views[idx].layoutIfNeeded()
        }
    }
    
    private func initializeStatViewColor() {
        guard let views = statView, let colors = gradientColor else {
            return
        }
        for index in 0..<views.count {
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.colors = [colors[index], colors[index+1]]
            gradient.locations = [0.0, 1.0]
            gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
            gradient.frame = views[index].bounds
            gradient.cornerRadius = 5
            views[index].layer.addSublayer(gradient)
        }

    }
    
    private func attachObjet() {
        guard let views = statView else {
            return
        }
        for idx in 0..<objetImage.count {
            guard let img = objetImage[idx] else {
                return
            }
            if views[idx].bounds.height > 85 {
                let imgView = UIImageView(frame: CGRect(x: 0,
                                                        y: 30,
                                                        width: views[idx].bounds.width,
                                                        height: img.size.height))
                imgView.image = img
                views[idx].addSubview(imgView)
            }
        }
    }
    
    private func initializeLabels() {
        guard let labels = statNumLabel, let unwrappedDepthLabel = depthLabel else {
            return
        }
        for num in 0..<labels.count {
            labels[num].attributedText = "\(depthStatData[num])".wordTextSpacing(textSpacing: -0.6, lineSpacing: 4, center: true, truncated: false)
            unwrappedDepthLabel[num].attributedText = depth[num].textSpacing()
        }
    }

}
