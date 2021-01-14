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
        static let diaryStoryboard: String = "Diary"
        static let joinStoryboard: String = "Join"
        static let emailLoginStoryboard: String = "EmailLogin"
        static let loginStoryboard: String = "Login"
        static let diaryWriteStoryboard: String = "DiaryWrite"
        static let findPasswordStoryboard: String = "FindPassword"
        
        // MARK: - Nib Name Constants
        
        static let homeDayNightViewXib: String = "HomeDayNightView"
        static let bubbleTableViewCell: String = "BubbleTableViewCell"
        
    }
    
    // MARK: - Identifier Contants
    
    struct Identifier {
        // MARK: - ViewController
        
        static let homeViewController: String = "HomeViewController"
        static let onboardingViewController: String = "OnboardingViewController"
        static let onboardingWriteViewController: String = "OnboardingWriteViewController"
        static let moodViewController: String = "MoodViewController"
        static let sentenceViewController: String = "SentenceViewController"
        static let deepViewController: String = "DeepViewController"
        static let diaryViewController: String = "DiaryViewController"
        static let joinViewController: String = "JoinViewController"
        static let emailLoginViewController: String = "EmailLoginViewController"
        static let loginViewController: String = "LoginViewController"
        static let diaryWriteViewController: String = "DiaryWriteViewController"
        static let findPasswordViewController: String = "FindPasswordViewController"
        
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
            
            // objet - depth number 0
            static let depth0Seaweed1 = UIImage(named: "2MSeaweed1")
            static let depth0Rock1 = UIImage(named: "2MRock1")
            static let depth0Rock2 = UIImage(named: "2MRock2")
            static let depth0Fish1 = UIImage(named: "2MFish1")
            static let depth0Fish2 = UIImage(named: "2MFish2")
            
            // objet - depth number 1
            static let depth1Rock1 = UIImage(named: "30MRock1")
            static let depth1Seaweed = UIImage(named: "30MSeaweed")
            static let depth1Dolphin1 = UIImage(named: "30MDolphin1")
            static let depth1Dolphin2 = UIImage(named: "30MDolphin2")
            static let depth1Coral1 = UIImage(named: "30MCoral1")
            static let depth1Fish1 = UIImage(named: "30MFish1")
            
            // objet - depth number 2
            static let depth2Fish1 = UIImage(named: "100MFish1")
            static let depth2Fish2 = UIImage(named: "100MFish2")
            static let depth2Turtle1 = UIImage(named: "100MTurtle1")
            static let depth2Turtle2 = UIImage(named: "100MTurtle2")
            static let depth2Seaweed1 = UIImage(named: "100MSeaweed1")
            static let depth2Seaweed2 = UIImage(named: "100MSeaweed2")
            
            // objet - depth number 3
            static let depth3Seaweed1 = UIImage(named: "300MSeaweed1")
            static let depth3Seaweed2 = UIImage(named: "300MSeaweed2")
            static let depth3Seaweed3 = UIImage(named: "300MSeaweed3")
            static let depth3Fish1 = UIImage(named: "300MFish1")
            static let depth3Fish2 = UIImage(named: "300MFish2")
            static let depth3Stingray1 = UIImage(named: "300MStingray1")
            static let depth3Rock1 = UIImage(named: "300MRock1")
            
            // objet - depth number 4
            static let depth4Seaweed1 = UIImage(named: "700MSeaweed1")
            static let depth4Seaweed2 = UIImage(named: "700MSeaweed2")
            static let depth4Rock1 = UIImage(named: "700MRock1")
            static let depth4Whale1 = UIImage(named: "700MWhale1")
            static let depth4Fish1 = UIImage(named: "700MFish1")
            
            // objet - depth number 5
            static let depth5Seaweed1 = UIImage(named: "1005MSeaweed1")
            static let depth5Seaweed2 = UIImage(named: "1005MSeaweed2")
            static let depth5Shark = UIImage(named: "1005MShark")
            static let depth5Rock1 = UIImage(named: "1005MRock1")
            
            // objet - depth number 6
            static let depth6Rock1 = UIImage(named: "underRock1")
            static let depth6Seaweed1 = UIImage(named: "underSeaweed1")
            static let depth6Sea = UIImage(named: "underSea")
            static let depth6bottom = UIImage(named: "bottomSea")

            static let icLove14Black = UIImage(named: "icLove14Black")
            static let icHappy14Black = UIImage(named: "icHappy14Black")
            static let icConsole14Black = UIImage(named: "icConsole14Black")
            static let icAngry14Black = UIImage(named: "icAngry14Black")
            static let icSad14Black = UIImage(named: "icSad14Black")
            static let icBored14Black = UIImage(named: "icBored14Black")
            static let icMemory14Black = UIImage(named: "icMemory14Black")
            static let icDaily14Black = UIImage(named: "icDaily14Black")
            static let textfieldDelete = UIImage(named: "textfieldDelete")
            
            // join checkbox
            static let loginCheckboxIntermediate = UIImage(named: "loginCheckboxIntermediate")
            static let loginCheckbox = UIImage(named: "loginCheckbox")
            static let icStep = UIImage(named: "icStep")
            static let label2m = UIImage(named: "2M")
            static let label30m = UIImage(named: "30M")
            static let label100m = UIImage(named: "100M")
            static let label300m = UIImage(named: "300M")
            static let label700m = UIImage(named: "700M")
            static let label1005m = UIImage(named: "1005M")
            static let labelDeepSea = UIImage(named: "deepSea")
            
            //button
            static let btnCloseBlack = UIImage(named: "btnCloseBlack")
            static let btnBackBlack = UIImage(named: "btnBackBlack")
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
