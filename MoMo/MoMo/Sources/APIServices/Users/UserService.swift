//
//  File.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/02/11.
//

import Foundation
import Alamofire

struct UserService {
    
    static let shared = UserService()
    
    // MARK: - DELETE
    
    func deleteUser(userId: Int,
                    completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = APIConstants.usersURL + "/\(userId)"
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": UserDefaults.standard.string(forKey: "token") ?? ""
        ]
        let body: Parameters = [:]
        
        let dataRequest = AF.request(url,
                                     method: .delete,
                                     parameters: body,
                                     encoding: URLEncoding.default,
                                     headers: header)
        dataRequest.responseData { (response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }
                completion(judgeDeleteUserData(status: statusCode, data: data))
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    private func judgeDeleteUserData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<User>.self, from: data) else {
            return .pathErr
        }
        switch status {
        case 200:
            return .success(decodedData.message)
        case 400:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
            
        }
    }
    
}

