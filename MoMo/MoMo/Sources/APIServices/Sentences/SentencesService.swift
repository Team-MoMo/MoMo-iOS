//
//  SentencesService.swift
//  MoMo
//
//  Created by 이정엽 on 2021/01/14.
//

import Foundation
import Alamofire

struct SentencesService {
    
    // 싱글톤 객체 생성
    static let shared = SentencesService()
    
    // 다이어리 통신에 대한 함수 정의
    // get
    func getSentences( emotionId: String,
                     userId: String,
                     completion: @escaping (NetworkResult<Any>) -> (Void)) {
        
        let url = APIConstants.sentencesURL
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": UserDefaults.standard.string(forKey: "token") ?? ""
        ]
        let body: Parameters = [
            "emotionId" : emotionId,
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
        guard let decodedData = try? decoder.decode(GenericResponse<[Sentence]>.self,
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
