//
//  Sentence.swift
//  MoMo
//
//  Created by 초이 on 2021/01/13.
//

import Foundation

// MARK: - Sentence

struct Sentence: Codable {
    let id: Int
    let contents, bookName, writer, publisher: String
    let createdAt, updatedAt: String
    let blindedAt, deletedAt: String?
}
