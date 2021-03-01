//
//  APIConstants.swift
//  MoMo
//
//  Created by 초이 on 2020/12/28.
//

import Foundation

struct APIConstants {
    
    // MARK: - base URL
    
    static let baseURL = "https://momodiary.ga"
    
    static var userId: Int = UserDefaults.standard.integer(forKey: "userId") {
        willSet(newUserId) {
            userInfoURL = usersURL + "/\(newUserId)"
            diaryWithUserIdURL = diariesURL + "/\(newUserId)"
        }
    }
    
    // MARK: - Users
    
    static let usersURL = baseURL + "/users"
    
    // 회원가입(post), 이메일 확인(get) url
    static let signUpURL = usersURL + "/signup"
    // 로그인 url
    static let signInURL = usersURL + "/signin"
    // 소셜로그인 url
    static let socialSignInURL = signInURL + "/social"
    // 회원 조회(get), 회원 탈퇴(delete) url
    static var userInfoURL = usersURL + "/\(userId)" {
        willSet(newUserInfoURL) {
            alarmURL = newUserInfoURL + "/alarm"
            passwordURL = newUserInfoURL + "/password"
        }
    }
    // 알람 변경 url
    static var alarmURL = userInfoURL + "/alarm"
    // 비밀번호 변경(put), 확인(post) url
    static var passwordURL = userInfoURL + "/password"
    // 임시 비밀번호 발급 url
    static let tempPasswordURL = usersURL + "/password/temp"
    
    // MARK: - Diaries
    
    static let diariesURL = baseURL + "/diaries"
    
    // 일기 작성이 안된 가장 최근 날짜 조회
    static let diaryRecentURL = baseURL + "/diaries/recent"
    
    // 일기 통계 조회 url
    static let statisticsURL = diariesURL + "/statistics"
    // 일기 조회(get), 수정(put), 삭제(delete) url
    static var diaryWithUserIdURL = diariesURL + "/\(userId)"
    
    // MARK: - Sentences
    
    // 문장 등록(post), 조회(get) url
    static let sentencesURL = baseURL + "/sentences"
    
    // MARK: - Emotions
    
    // 감정 전체 조회
    static let emotionsURL = baseURL + "/emotions"
}
