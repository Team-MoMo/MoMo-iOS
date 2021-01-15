//
//  DiaryRecentService.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/15.
//

import Foundation
import Alamofire

struct DiaryRecentService {
    static let shared = DiaryRecentService()
    
    // 다이어리 통신에 대한 함수 정의
    // get
    func getDiaryRecent(userId: String,
                     completion: @escaping (NetworkResult<Any>) -> (Void)) {
        
        let url = APIConstants.diaryRecentURL
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": UserDefaults.standard.string(forKey: "token") ?? ""
        ]
        
        let body: Parameters = [
            "userId": userId
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
                completion(judgeGetSentenceData(status: statusCode, data: data))
            
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    private func judgeGetSentenceData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<String>.self,
                                                    from: data) else {
            return .pathErr
        }
        
        switch status {
        case 200:
            return .success(decodedData.data)
        case 400:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
