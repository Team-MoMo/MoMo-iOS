//
//  SignInService.swift
//  MoMo
//
//  Created by 초이 on 2021/01/14.
//

import Foundation
import Alamofire

struct SignInService {
    
    static let shared = SignInService()
    
    // MARK: - POST
    
    func postSignIn(email: String,
                   password: String,
                   completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = APIConstants.signInURL
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
                completion(doSignIn(status: statusCode, data: data))
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    private func doSignIn(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<AuthData>.self, from: data) else {
            return .pathErr
        }
        print(decodedData)
        
        switch status {
        case 200:
            // 로그인 성공
            //print(decodedData.data)
            return .success(decodedData.data)
        case 400:
            // 존재하지 않는 회원
            return .requestErr(decodedData.message)
        case 500:
            // 서버 내부 에러
            return .serverErr
        default:
            return .networkFail
            
        }
    }
}
