//
//  DiaryInfo.swift
//  MoMo
//
//  Created by 초이 on 2021/01/27.
//

import UIKit

// TODO: - 해석이오빠가 리팩토링하면서 네이밍 변경하거나 없애기
struct AppDiary {
    var date: String
    var year: Int
    var month: Int
    var day: Int
    var mood: AppEmotion
    var depth: AppDepth
    var sentence: AppSentence
    var diary: String
}
