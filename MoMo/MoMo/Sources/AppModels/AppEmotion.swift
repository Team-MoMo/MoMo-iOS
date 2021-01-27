//
//  Emotion.swift
//  MoMo
//
//  Created by 초이 on 2021/01/27.
//

import UIKit

enum AppEmotion: Int {
    case love = 1, happy, console, angry, sad, bored, memory, daily
    
    func toString() -> String {
        switch self {
        case .love:
            return "사랑"
        case .happy:
            return "행복"
        case .console:
            return "위로"
        case .angry:
            return "화남"
        case .sad:
            return "슬픔"
        case .bored:
            return "우울"
        case .memory:
            return "추억"
        case .daily:
            return "일상"
        }
    }
    
    func toIcon() -> UIImage {
        switch self {
        case .love:
            return Constants.Design.Image.icLove14Black!
        case .happy:
            return Constants.Design.Image.icHappy14Black!
        case .console:
            return Constants.Design.Image.icConsole14Black!
        case .angry:
            return Constants.Design.Image.icAngry14Black!
        case .sad:
            return Constants.Design.Image.icSad14Black!
        case .bored:
            return Constants.Design.Image.icBored14Black!
        case .memory:
            return Constants.Design.Image.icMemory14Black!
        case .daily:
            return Constants.Design.Image.icDaily14Black!
        }
    }
    
    func toWhiteIcon() -> UIImage {
        switch self {
        case .love:
            return Constants.Design.Image.icLove14White!
        case .happy:
            return Constants.Design.Image.icHappy14White!
        case .console:
            return Constants.Design.Image.icConsole14White!
        case .angry:
            return Constants.Design.Image.icAngry14White!
        case .sad:
            return Constants.Design.Image.icSad14White!
        case .bored:
            return Constants.Design.Image.icBored14White!
        case .memory:
            return Constants.Design.Image.icMemory14White!
        case .daily:
            return Constants.Design.Image.icDaily14White!
        }
    }
    
    func toBlueIcon() -> UIImage {
        switch self {
        case .love:
            return Constants.Design.Image.icLove14Blue!
        case .happy:
            return Constants.Design.Image.icHappy14Blue!
        case .console:
            return Constants.Design.Image.icConsole14Blue!
        case .angry:
            return Constants.Design.Image.icAngry14Blue!
        case .sad:
            return Constants.Design.Image.icSad14Blue!
        case .bored:
            return Constants.Design.Image.icBored14Blue!
        case .memory:
            return Constants.Design.Image.icMemory14Blue!
        case .daily:
            return Constants.Design.Image.icDaily14Blue!
        }
    }
    
    func toTypingLabelText() -> String {
        switch self {
        case .love:
            return "새로운 인연이 기대되는 하루였다. "
        case .happy:
            return "삶의 소중함을 느낀 하루였다. "
        case .console:
            return "나를 위한 진한 위로가 필요한 하루였다. "
        case .angry:
            return "끓어오르는 속을 진정시켜야 하는 하루였다. "
        case .sad:
            return "마음이 찌릿하게 아픈 하루였다. "
        case .bored:
            return "눈물이 왈칵 쏟아질 것 같은 하루였다. "
        case .memory:
            return "오래된 기억이 되살아나는 하루였다. "
        case .daily:
            return "평안한 하루가 감사한 날이었다."
        }
    }
}
