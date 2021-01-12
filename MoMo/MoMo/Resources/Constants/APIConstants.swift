//
//  APIConstants.swift
//  MoMo
//
//  Created by 초이 on 2020/12/28.
//

import Foundation

struct APIConstants {
    
    // MARK: - base URL
    
    static let baseURL = "http://3.36.79.14:3000"
    
    // TODO: - 유저 토큰.. 이거 force unwrapping 해도 되나;
    static let token: String = UserDefaults.standard.object(forKey: "token") as! String
    
    // MARK: - Users
    
    static let usersURL = baseURL + "/users"
    
    // 회원가입(post), 이메일 확인(get) url
    static let signUpURL = usersURL + "/signup"
    // 로그인 url
    static let signInURL = usersURL + "/signin"
    // 회원 조회(get), 회원 탈퇴(delete) url
    static let userInfoURL = usersURL + token
    // 알람 변경 url
    static let alarmURL = usersURL + token + "/alarm"
    // 비밀번호 변경(put), 확인(post) url
    static let passwordURL = usersURL + token + "/password"
    // 임시 비밀번호 발급 url
    static let tempPasswordURL = usersURL + "/password/temp"
    
    // MARK: - Diaries
    
    static let diariesURL = baseURL + "/diaries"
    
    // 일기 통계 조회 url
    static let statisticsURL = diariesURL + "/statistics"
    // 일기 조회(get), 수정(put), 삭제(delete) url
    static let diaryURL = diariesURL + token
    
    // MARK: - Sentences
    
    // 문장 등록(post), 조회(get) url
    static let sentencesURL = baseURL + "/sentences"
    
    // MARK: - Emotions
    
    // 감정 전체 조회
    static let emotionsURL = baseURL + "/emotions"
}
