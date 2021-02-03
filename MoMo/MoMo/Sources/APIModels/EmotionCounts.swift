//
//  emotionCounts.swift
//  MoMo
//
//  Created by 이정엽 on 2021/02/03.
//

import Foundation

struct EmotionCounts: Codable {
    let id : Int
    let count: Int
    let emotionId: Int
    let emotionName: String
    let emotionCreatedAt: String
    let emotionUpdatedAt: String
}

enum CodingKeys: String, CodingKey {
    case id,count
    case emotionId = "Emotion.id"
    case emotionName = "Emotion.name"
    case emotionCreatedAt = "Emotion.createdAt"
    case emotionUpdatedAt = "Emotion.updatedAt"
}
