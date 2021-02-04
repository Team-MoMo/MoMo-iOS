//
//  emotionCounts.swift
//  MoMo
//
//  Created by 이정엽 on 2021/02/03.
//

import Foundation

struct EmotionCount: Codable {
    let id, count, emotionID: Int
    let emotionName, emotionCreatedAt, emotionUpdatedAt: String
    let emotionDeletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, count
        case emotionID = "Emotion.id"
        case emotionName = "Emotion.name"
        case emotionCreatedAt = "Emotion.createdAt"
        case emotionUpdatedAt = "Emotion.updatedAt"
        case emotionDeletedAt = "Emotion.deletedAt"
    }
}
