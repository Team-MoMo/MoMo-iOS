//
//  ListTableViewCell.swift
//  MoMo
//
//  Created by 이정엽 on 2020/12/29.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var journalView: UIView!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var journalLabel1: UILabel!
    @IBOutlet weak var journalLabel2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(list: List) {
        iconImage.image = list.makeImage()
        categoryLabel.text = list.category
        dateLabel.text = list.date
        dayLabel.text = list.day
        depthLabel.text = list.depth
        authorLabel.text = list.author
        titleLabel.text = list.title
        publisherLabel.text = list.publisher
        
        }
    
    func quoteSpacing(_ text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.kern, value: -0.6, range: NSRange(location: 0, length: attributedString.length))
        quoteLabel.attributedText = attributedString
    }
    
    func journaltext(_ text: String, _ size: CGFloat) {
        let labelSize: CGSize = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 13, weight: .regular)])
        let verify = "힣".size(withAttributes: [.font: UIFont.systemFont(ofSize: 13, weight: .regular)]).width
        let breakpoint: Int
        
        if labelSize.width > size {
            breakpoint = Int(size/verify)+1
            let breakIndex: String.Index = text.index(text.startIndex, offsetBy: breakpoint)
            let firstString = NSMutableAttributedString(string: String(text[..<breakIndex]))
            let secondString = NSMutableAttributedString(string: String(text[breakIndex...]))
            firstString.addAttribute(NSAttributedString.Key.kern, value: -0.6, range: NSRange(location: 0, length: firstString.length))
            secondString.addAttribute(NSAttributedString.Key.kern, value: -0.6, range: NSRange(location: 0, length: secondString.length))
            
            journalLabel1.attributedText = firstString
            journalLabel2.attributedText = secondString
        } else {
            let firstString = NSMutableAttributedString(string: text)
            firstString.addAttribute(NSAttributedString.Key.kern, value: -0.6, range: NSRange(location: 0, length: firstString.length))
            journalLabel1.attributedText = firstString
            
        }
    }
    
    @IBAction func touchButton(_ sender: Any) {
        print(1)
    }
    
    func setLabelUnderline(_ size1: CGFloat, _ size2: CGFloat) {
        let firstString = journalLabel1.text!
        let secondString = journalLabel2.text!
        let firstLabelSize: CGSize = firstString.size(withAttributes: [.font: UIFont.systemFont(ofSize: 12, weight: .regular)])
        let secondLabelSize: CGSize = secondString.size(withAttributes: [.font: UIFont.systemFont(ofSize: 12, weight: .regular)])

        let border1 = CALayer()
        let border2 = CALayer()
        
        border1.frame = CGRect(x: 0, y: Int(self.journalLabel1.frame.height) - 1, width: Int(firstLabelSize.width), height: 1)
        border1.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor
        
        if secondLabelSize.width < size2 {
            border2.frame = CGRect(x: 0, y: self.journalLabel2.frame.height - 1, width: secondLabelSize.width, height: 1)
        } else {
            border2.frame = CGRect(x: 0, y: self.journalLabel2.frame.height - 1, width: size2, height: 1)
        }
        border2.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor

        journalLabel1.layer.addSublayer(border1)
        journalLabel2.layer.addSublayer(border2)
    }

}
