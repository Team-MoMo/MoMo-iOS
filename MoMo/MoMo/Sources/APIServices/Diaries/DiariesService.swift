//
//  diariesService.swift
//  MoMo
//
//  Created by 초이 on 2021/01/13.
//

import Foundation
import Alamofire

struct DiariesService {
    
    // 싱글톤 객체 생성
    static let shared = DiariesService()
    
    // 다이어리 통신에 대한 함수 정의
    // get
    func getDiaries( userId: String,
                     year: String,
                     month: String,
                     order: String?,
                     emotionId: String?,
                     depth: String?,
                     completion: @escaping (NetworkResult<Any>) -> (Void)) {
        
        let url = APIConstants.diariesURL
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": UserDefaults.standard.string(forKey: "token") ?? ""
        ]
        let body: Parameters = [
            "userId": userId,
            "year": year,
            "month": month,
//            "order": "",
//            "emotionId": "",
//            "depth": ""
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
                completion(judgeGetDiaryData(status: statusCode, data: data))
            
            case .failure(let err): print(err)
                completion(.networkFail)
            }
        }
    }
    
    private func judgeGetDiaryData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<[Diary]>.self,
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
    
    func postDiaries(contents: String,
                         depth: Int,
                         userId: Int,
                         sentenceId: Int,
                         emotionId: Int,
                         wroteAt: String,
                         completion: @escaping (NetworkResult<Any>) -> (Void)) {
            
        let url = APIConstants.diariesURL
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": UserDefaults.standard.string(forKey: "token") ?? ""
        ]
        let body: Parameters = [
            "contents" : contents,
            "depth" : depth,
            "userId" : userId,
            "sentenceId" : sentenceId,
            "emotionId" : emotionId,
            "wroteAt" : wroteAt
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
                completion(judgePostDiaryData(status: statusCode, data: data))
                
            case .failure(let err): print(err)
                completion(.networkFail)
            }
        }
    }
        
    private func judgePostDiaryData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<CreateDiary>.self,
                                                        from: data) else {
            return .pathErr
        }
            
        switch status{
        case 201:
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
