//
//  OnboardingSentence.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/15.
//

import Foundation


// MARK: - DataClass
struct OnboardingSentence: Codable {
    let emotionID: Int
    let sentence01, sentence02, sentence03: Sentence0

    enum CodingKeys: String, CodingKey {
        case emotionID = "emotionId"
        case sentence01 = "sentence_01"
        case sentence02 = "sentence_02"
        case sentence03 = "sentence_03"
    }
}

// MARK: - Sentence0
struct Sentence0: Codable {
    let contents, bookName, writer, publisher: String
}
