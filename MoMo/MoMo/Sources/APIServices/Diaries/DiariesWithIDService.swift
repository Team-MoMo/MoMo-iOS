//
//  DiariesWithIDService.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/14.
//

import Foundation
import Alamofire

struct DiariesWithIDService {
    
    // 싱글톤 객체 생성
    static let shared = DiariesWithIDService()
    
    func getDiaryWithDiaryId (
        diaryId: Int,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        let url = APIConstants.diaryWithUserIdURL
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": UserDefaults.standard.string(forKey: "token") ?? ""
        ]
        let body: Parameters = [:]
        
        let dataRequest = AF.request(
            url,
            method: .get,
            parameters: body,
            encoding: URLEncoding.default,
            headers: header
        )
        
        dataRequest.responseData { (response) in
            
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                completion(judgeGetDiaryWithDiaryIdData(status: statusCode, data: data))
                
            case .failure(let err): print(err)
                completion(.networkFail)
            }
        }
    }
    
    func putDiaryWithDiaryId (
        diaryId: Int,
        depth: Int,
        contents: String,
        userId: Int,
        sentenceId: Int,
        emotionId: Int,
        wroteAt: String,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        
        let url = APIConstants.diaryWithUserIdURL
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": UserDefaults.standard.string(forKey: "token") ?? ""
        ]
        let body: Parameters = [
            "depth": depth,
            "contents": contents,
            "userId": userId,
            "sentenceId": sentenceId,
            "emotionId": emotionId,
            "wroteAt": wroteAt
        ]
        
        let dataRequest = AF.request(
            url,
            method: .put,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: header
        )
        
        dataRequest.responseData { (response) in
            
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                completion(judgePutDiaryWithDiaryIdData(status: statusCode, data: data))
                
            case .failure(let err): print(err)
                completion(.networkFail)
            }
        }
    }
    
    func deleteDiaryWithDiaryId (
        diaryId: Int,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        
        let url = APIConstants.diaryWithUserIdURL
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": UserDefaults.standard.string(forKey: "token") ?? ""
        ]
        let body: Parameters = [:]
        
        let dataRequest = AF.request(
            url,
            method: .delete,
            parameters: body,
            encoding: URLEncoding.default,
            headers: header
        )
        
        dataRequest.responseData { (response) in
            
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    return
                }
                guard let data = response.value else {
                    return
                }
                completion(judgeDeleteDiaryWithDiaryIdData(status: statusCode, data: data))
                
            case .failure(let err): print(err)
                completion(.networkFail)
            }
        }
    }
    
    private func judgeGetDiaryWithDiaryIdData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<Diary>.self, from: data) else {
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
    
    private func judgePutDiaryWithDiaryIdData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<Diary>.self, from: data) else {
            return .pathErr
        }
        
        switch status {
        case 200:
            return .success(decodedData.data)
        case 400...401:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func judgeDeleteDiaryWithDiaryIdData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<Diary>.self, from: data) else {
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
