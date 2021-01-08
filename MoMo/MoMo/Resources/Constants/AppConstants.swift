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
        
        // MARK: - Nib Name Constants
        
    }
    
    // MARK: - Identifier Contants
    
    struct Identifier {
        static let homeViewController: String = "HomeViewController"
        static let onboardingViewController: String = "OnboardingViewController"
        static let onboardingMoodViewController: String = "OnboardingMoodViewController"
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
        }
        
        struct Font {
            /// 예시 : static let Body = UIFont.systemFont(ofSize: 16, weight: .regular)
            /// 사용 : label.font = Constants.Design.Font.Body
        }
        
    }
    
    // MARK: - Content Constants
    
    struct Content {
        /// 예시 : static let Category = "category"
    }
    
}
