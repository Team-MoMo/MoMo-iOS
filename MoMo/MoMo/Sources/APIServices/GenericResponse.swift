//
//  GenericResponse.swift
//  MoMo
//
//  Created by 초이 on 2021/01/13.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {
    var message: String
    var data: T?
    var error: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        case data
        case error
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
        error = (try? values.decode(String.self, forKey: .error)) ?? nil
    }
}
