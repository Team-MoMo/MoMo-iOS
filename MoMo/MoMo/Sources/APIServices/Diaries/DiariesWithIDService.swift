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
    
    func getDiaryWithID (
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        let url = APIConstants.diaryWithIdURL
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
                completion(judgeGetDiaryData(status: statusCode, data: data))
                
            case .failure(let err): print(err)
                completion(.networkFail)
            }
        }
    }
    
    func putDiaryWithID (
        depth: Int,
        contents: String,
        sentenceId: Int,
        emotionId: Int,
        wroteAt: String,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        
        let url = APIConstants.diaryWithIdURL
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": UserDefaults.standard.string(forKey: "token") ?? ""
        ]
        let body: Parameters = [
            "depth": depth,
            "contents": contents,
            "userId": APIConstants.id,
            "sentenceId": sentenceId,
            "emotionId": emotionId,
            "wroteAt": wroteAt
        ]
        
        let dataRequest = AF.request(
            url,
            method: .put,
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
                completion(judgePutDiaryData(status: statusCode, data: data))
                
            case .failure(let err): print(err)
                completion(.networkFail)
            }
        }
    }
    
    func deleteDiaryWithID (
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        
        let url = APIConstants.diaryWithIdURL
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
                completion(judgeDeleteDiaryData(status: statusCode, data: data))
                
            case .failure(let err): print(err)
                completion(.networkFail)
            }
        }
    }
    
    private func judgeGetDiaryData(status: Int, data: Data) -> NetworkResult<Any> {
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
    
    private func judgePutDiaryData(status: Int, data: Data) -> NetworkResult<Any> {
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
    
    private func judgeDeleteDiaryData(status: Int, data: Data) -> NetworkResult<Any> {
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
