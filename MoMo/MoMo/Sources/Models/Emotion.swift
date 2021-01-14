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
    case 사랑 = "사랑"
    case 슬픔 = "슬픔"
    case 위로 = "위로"
    case 일상 = "일상"
    case 행복 = "행복"
}
