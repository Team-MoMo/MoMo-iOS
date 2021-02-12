//
//  PasswordService.swift
//  MoMo
//
//  Created by 초이 on 2021/01/14.
//

import Foundation
import Alamofire

struct PasswordService {
    
    static let shared = PasswordService()
    
    // MARK: - PUT
    
    func putPassword(newPassword: String,
                   completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = APIConstants.passwordURL
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": UserDefaults.standard.string(forKey: "token") ?? ""
        ]
        let body: Parameters = [
            "newPassword": newPassword
        ]
        
        let dataRequest = AF.request(url,
                                     method: .put,
                                     parameters: body,
                                     encoding: URLEncoding.default,
                                     headers: header)
        dataRequest.responseData { (response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                completion(changePassword(status: statusCode, data: data))
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    private func changePassword(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<PasswordData>.self, from: data) else {
            return .pathErr
        }
        
        switch status {
        case 200:
            // 비밀번호 수정 성공
            return .success(decodedData.message)
        case 400:
            // 권한이 없습니다
            return .requestErr(decodedData.message)
        case 500:
            // 비밀번호 수정 실패
            return .serverErr
        default:
            return .networkFail
            
        }
    }
    
    // MARK: - POST
    
    func postPassword(password: String,
                    completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = APIConstants.passwordURL
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": UserDefaults.standard.string(forKey: "token") ?? ""
        ]
        let body: Parameters = [
            "password": password
        ]
        
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: URLEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { (response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                completion(verifyPassword(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    private func verifyPassword(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<PasswordData>.self, from: data) else {
            return .pathErr
        }
        
        switch status {
        case 200:
            // 비밀번호가 일치합니다
            return .success(decodedData.message)
        case 400:
            // 권한이 없습니다
            return .requestErr(decodedData.message)
        case 500:
            // 서버 내부 오류
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    // MARK: - POST 임시비밀번호 발급
    
    func postTempPassword(email: String,
                    completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = APIConstants.tempPasswordURL
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": UserDefaults.standard.string(forKey: "token") ?? ""
        ]
        let body: Parameters = [
            "email": email
        ]
        
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { (response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                completion(createTempPassword(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    private func createTempPassword(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<TempPassword>.self, from: data) else {
            return .pathErr
        }
        
        switch status {
        case 200:
            // 임시 비밀번호 생성 성공
            return .success(decodedData.data)
        case 400:
            // 존재하지 않는 회원
            // 임시비밀번호 발급 횟수 초과
            return .requestErr(decodedData.message)
        case 500:
            // 서버 내부 오류
            // 임시비밀번호 생성 실패
            return .serverErr
        default:
            return .networkFail
        }
    }
}
