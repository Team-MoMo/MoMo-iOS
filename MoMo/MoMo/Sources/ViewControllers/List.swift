//
//  List.swift
//  MoMo
//
//  Created by 이정엽 on 2020/12/31.
//

import Foundation
import UIKit

struct List {
    var iconImage: String
    var category: String
    var date: String
    var day: String
    var depth: String
    var quote: String
    var author: String
    var title: String
    var publisher: String
    var journal: String
    
    func makeImage() -> UIImage? {
        return UIImage(named: iconImage)
    }
}
