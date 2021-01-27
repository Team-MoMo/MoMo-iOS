//
//  PasswordData.swift
//  MoMo
//
//  Created by 초이 on 2021/01/14.
//

import Foundation

// MARK: - PasswordData

struct PasswordData: Codable {
    let id: Int
    let email, password, passwordSalt: String
    let isAlarmSet: Bool
    let alarmTime, tempPassword, tempPasswordCreatedAt: String
    let tempPasswordIssueCount: Int
    let createdAt, updatedAt: String
}
