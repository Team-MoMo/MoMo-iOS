//
//  NetworkResult.swift
//  MoMo
//
//  Created by 초이 on 2021/01/13.
//

import Foundation
//서버 통신과의 성공, 실패 등을 처리해주기 위한 열거형(enum) 타입
// 서버 통신에 대한 결과(성공, 요청에러, 경로에러, 서버내부에러, 네트워크 연결 실패)
enum NetworkResult<T> {
    case success(T) //임의로 만든 데이터 T 를 담아서 보낼 수 있음
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}
