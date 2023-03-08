//
//  ServiceEndService.swift
//  MoMo
//
//  Created by Haeseok Lee on 2023/03/07.
//

import Foundation
import Alamofire

struct ServiceEndService {
    
    static let shared = ServiceEndService()
    
    // MARK: - POST
    
    func postDiaryExport(userID: Int, email: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = APIConstants.diariesExportURL
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": UserDefaults.standard.string(forKey: "token") ?? ""
        ]
        
        let body: Parameters = [
            "userId": userID,
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
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }
                completion(judgeDiaryExportData(status: statusCode, data: data))
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    private func judgeDiaryExportData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<String>.self, from: data) else {
            return .pathErr
        }
        switch status {
        case 200:
            return .success(decodedData.message)
        case 400...401:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
            
        }
    }
    
}
