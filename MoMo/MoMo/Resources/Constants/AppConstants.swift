//
//  AppConstants.swift
//  MoMo
//
//  Created by 초이 on 2020/12/28.
//

import Foundation
import UIKit

struct Constants {
    
    // MARK: - Name Contants
    
    struct Name {
        
        // MARK: - Storyboard Name Constants
        
        static let homeStoryboard: String = "Home"
        static let onboardingStoryboard: String = "Onboarding"
        static let emailLoginStoryboard: String = "EmailLogin"
        static let loginStoryboard: String = "Login"
        
        // MARK: - Nib Name Constants
        
        static let homeDayNightViewXib: String = "HomeDayNightView"
        static let bubbleTableViewCell: String = "BubbleTableViewCell"
        
    }
    
    // MARK: - Identifier Contants
    
    struct Identifier {
        // MARK: - ViewController
        
        static let homeViewController: String = "HomeViewController"
        static let onboardingViewController: String = "OnboardingViewController"
        static let DiaryWirteViewController: String = "DiaryWirteViewController"
        static let onboardingWriteViewController: String = "OnboardingWriteViewController"
        static let moodViewController: String = "MoodViewController"
        static let sentenceViewController: String = "SentenceViewController"
        static let deepViewController: String = "DeepViewController"
        static let emailLoginViewController: String = "EmailLoginViewController"
        static let loginViewController: String = "LoginViewController"
        
        // MARK: - UIView
        
        static let homeDayNightView: String = "HomeDayNightView"
        
        // MARK: - Xib Cell
        
        static let bubbleTableViewCell: String = "BubbleTableViewCell"
    }
    
    // MARK: - Design Constants
    
    struct Design {
        
        struct Color {
            /// Asset으로 Color 관리 할 거라 필요할 진 모르겠지만..
            /// 예시 : static let Blue = UIColor.rgba(red: 0, green: 122, blue: 255, alpha: 1) (Extension 함수 추가 필요)
            /// 사용 : Constants.Design.Color.Blue
            
        }
        
        struct Image {
            /// 예시 : static let IconHome = UIImage(named: "ico_category")
            static let homeIcSwipeDown = UIImage(named: "homeIcSwipeDown")
            static let btnIcMyBlue = UIImage(named: "btnIcMyBlue")
            static let icFeatherBlack = UIImage(named: "icFeatherBlack")
            static let btnIcMy = UIImage(named: "btnIcMy")
            static let icLove14Black = UIImage(named: "icLove14Black")
            static let icHappy14Black = UIImage(named: "icHappy14Black")
            static let icConsole14Black = UIImage(named: "icConsole14Black")
            static let icAngry14Black = UIImage(named: "icAngry14Black")
            static let icSad14Black = UIImage(named: "icSad14Black")
            static let icBored14Black = UIImage(named: "icBored14Black")
            static let icMemory14Black = UIImage(named: "icMemory14Black")
            static let icDaily14Black = UIImage(named: "icDaily14Black")
            static let icStep = UIImage(named: "icStep")
            static let label2m = UIImage(named: "2M")
            static let label30m = UIImage(named: "30M")
            static let label100m = UIImage(named: "100M")
            static let label300m = UIImage(named: "300M")
            static let label700m = UIImage(named: "700M")
            static let label1005m = UIImage(named: "1005M")
            static let labelDeepSea = UIImage(named: "deepSea")
        }
        
        struct Font {
            /// 예시 : static let Body = UIFont.systemFont(ofSize: 16, weight: .regular)
            /// 사용 : label.font = Constants.Design.Font.Body
        }
        
    }
    
    // MARK: - Content Constants
    
    struct Content {
        /// 예시 : static let Category = "category"
        
        static let depthNameArray: [String] = ["2m", "30m", "100m", "300m", "700m", "1,005m", "심해"]
    }
    
}
