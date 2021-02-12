//
//  SignUpService.swift
//  MoMo
//
//  Created by 초이 on 2021/01/14.
//

import Foundation
import Alamofire

struct SignUpService {
    
    static let shared = SignUpService()
    
    // MARK: - GET
    
    func getSignUp(email: String,
                   completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = APIConstants.signUpURL
        let header: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let body: Parameters = [
            "email": email
        ]
        
        let dataRequest = AF.request(url,
                                     method: .get,
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
                completion(verifyEmail(status: statusCode, data: data))
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    private func verifyEmail(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<AuthData>.self, from: data) else {
            return .pathErr
        }
        
        switch status {
        case 200:
            // 사용 가능한 이메일입니다
            return .success(decodedData.message)
        case 400:
            // 중복된 이메일인 경우
            // 사용 불가능한 이메일입니다
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
            
        }
    }
    
    // MARK: - POST
    
    func postSignUp(email: String,
                    password: String,
                    completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = APIConstants.signUpURL
        let header: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let body: Parameters = [
            "email": email,
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
                completion(doSignUp(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    private func doSignUp(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<AuthData>.self, from: data) else {
            return .pathErr
        }
        
        switch status {
        case 201:
            // 회원가입 성공
            return .success(decodedData.data)
        case 400:
            // 중복된 이메일
            return .requestErr(decodedData.message)
        case 500:
            // 서버 내부 에러
            return .serverErr
        default:
            return .networkFail
        }
    }
    
}
