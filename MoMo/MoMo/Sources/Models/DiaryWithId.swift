// MARK: - DataClass
struct DiaryWithId: Codable {
    let id, position, depth: Int
    let contents, wroteAt: String
    let userID, sentenceID, emotionID: Int
    let createdAt, updatedAt: String
    let sentence: Sentence
    let emotion: EmotionDiaryWithId

    enum CodingKeys: String, CodingKey {
        case id, position, depth, contents, wroteAt
        case userID = "userId"
        case sentenceID = "sentenceId"
        case emotionID = "emotionId"
        case createdAt, updatedAt
        case sentence = "Sentence"
        case emotion = "EmotionDiaryWithId"
    }
}

// MARK: - Emotion
struct EmotionDiaryWithId: Codable {
    let id: Int
    let name, createdAt, updatedAt: String
}
