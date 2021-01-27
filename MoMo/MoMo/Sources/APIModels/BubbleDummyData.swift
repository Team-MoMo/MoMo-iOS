//
//  BubbleDummyData.swift
//  MoMo
//
//  Created by 초이 on 2021/01/10.
//

import Foundation

// MARK: - Model

struct Bubble {
    var date: String
    var cate: String
    var depth: Int //0~6
    var leadingNum: Int //0~9
}

// MARK: - Dummy Data

struct BubbleData {
    var objectsArray = [
        Bubble(date: "12.1", cate: "0사랑", depth: 0, leadingNum: 0),
        Bubble(date: "12.10", cate: "0추억", depth: 0, leadingNum: 4),
        Bubble(date: "12.27", cate: "0행복", depth: 0, leadingNum: 7),
        Bubble(date: "12.28", cate: "0사랑", depth: 0, leadingNum: 9),
        Bubble(date: "12.31", cate: "0우짤", depth: 0, leadingNum: 4),
        Bubble(date: "12.12", cate: "1사랑", depth: 1, leadingNum: 5),
        Bubble(date: "12.6", cate: "1슬픔", depth: 1, leadingNum: 6),
        Bubble(date: "12.5", cate: "2화남", depth: 2, leadingNum: 5),
        Bubble(date: "12.9", cate: "3우울", depth: 3, leadingNum: 1),
        Bubble(date: "12.3", cate: "4위로", depth: 4, leadingNum: 4),
        Bubble(date: "12.8", cate: "4사랑", depth: 4, leadingNum: 6),
        Bubble(date: "12.4", cate: "5일상", depth: 5, leadingNum: 2),
        Bubble(date: "12.5", cate: "5일상", depth: 5, leadingNum: 1),
        Bubble(date: "12.4", cate: "5일상", depth: 5, leadingNum: 7),
        Bubble(date: "12.5", cate: "5일상", depth: 5, leadingNum: 3),
        Bubble(date: "12.4", cate: "5일상", depth: 5, leadingNum: 9),
        Bubble(date: "12.5", cate: "5일상", depth: 5, leadingNum: 2),
        Bubble(date: "12.7", cate: "6행복", depth: 6, leadingNum: 6),
        Bubble(date: "12.8", cate: "6행복", depth: 6, leadingNum: 4),
        Bubble(date: "12.7", cate: "6행복", depth: 6, leadingNum: 9),
        Bubble(date: "12.8", cate: "6행복", depth: 6, leadingNum: 1),
        Bubble(date: "12.7", cate: "6행복", depth: 6, leadingNum: 0),
        Bubble(date: "12.8", cate: "6행복", depth: 6, leadingNum: 2),
        Bubble(date: "12.7", cate: "6행복", depth: 6, leadingNum: 6),
        Bubble(date: "12.8", cate: "6행복", depth: 6, leadingNum: 7),
    ]
}
