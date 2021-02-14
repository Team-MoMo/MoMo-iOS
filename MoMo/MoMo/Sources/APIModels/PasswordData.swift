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
    let alarmTime: String?
    let tempPassword: String
    let tempPasswordCreatedAt: String?
    let tempPasswordIssueCount: Int
    let isDeleted: Bool
    let createdAt, updatedAt: String
    let deletedAt: String?
}
