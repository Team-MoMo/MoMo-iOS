//
//  TempPassword.swift
//  MoMo
//
//  Created by 초이 on 2021/02/12.
//

import Foundation

// MARK: - TempPassword

struct TempPassword: Codable {
    let email: String
    let tempPasswordIssueCount: Int
}
