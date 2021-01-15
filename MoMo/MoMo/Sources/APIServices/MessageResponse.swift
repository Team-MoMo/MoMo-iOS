//
//  MessageResponse.swift
//  MoMo
//
//  Created by 초이 on 2021/01/14.
//

import Foundation

struct MessageResponse: Codable {
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
    }
}
