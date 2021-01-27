//
//  Diary.swift
//  MoMo
//
//  Created by 초이 on 2021/01/13.
//

import Foundation

// MARK: - 다이어리

struct Diary: Codable {
    let id, position, depth: Int
    let contents, wroteAt: String
    let userID, sentenceID, emotionID: Int
    let createdAt, updatedAt: String
    let sentence: Sentence
    let emotion: Emotion

    enum CodingKeys: String, CodingKey {
        case id, position, depth, contents, wroteAt
        case userID = "userId"
        case sentenceID = "sentenceId"
        case emotionID = "emotionId"
        case createdAt, updatedAt
        case sentence = "Sentence"
        case emotion = "Emotion"
    }
}
