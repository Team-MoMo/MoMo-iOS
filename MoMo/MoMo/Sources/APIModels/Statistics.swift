//
//  DiaryStatistics.swift
//  MoMo
//
//  Created by 이정엽 on 2021/02/03.
//

import Foundation

struct Statistics: Codable {
    let emotionCounts: [EmotionCount]
    let depthCounts: [DepthCount]
}
