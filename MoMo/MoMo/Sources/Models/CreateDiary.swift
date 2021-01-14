//
//  CreateDiary.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/14.
//

struct CreateDiary: Codable {
    let id: Int
    let contents: String
    let depth, userID, sentenceID, emotionID: Int
    let wroteAt: String
    let position: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, contents, depth
        case userID = "userId"
        case sentenceID = "sentenceId"
        case emotionID = "emotionId"
        case wroteAt, position, createdAt, updatedAt
    }
}
