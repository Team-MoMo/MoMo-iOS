//
//  Emotion.swift
//  MoMo
//
//  Created by 초이 on 2021/01/13.
//

import Foundation

// MARK: - Emotion
struct Emotion: Codable {
    let id: Int
    let name: Name
    let createdAt, updatedAt: String
}

enum Name: String, Codable {
    case 사랑 = "사랑" // 1
    case 행복 = "행복" // 2
    case 위로 = "위로" // 3
    case 화남 = "화남" // 4
    case 슬픔 = "슬픔" // 5
    case 우울 = "우울" // 6
    case 추억 = "추억" // 7
    case 일상 = "일상" // 8
}
