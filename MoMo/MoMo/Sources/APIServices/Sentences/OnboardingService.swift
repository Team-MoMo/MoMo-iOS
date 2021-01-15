//
//  OnboardingService.swift
//  MoMo
//
//  Created by Haeseok Lee on 2021/01/15.
//

import Foundation

import Alamofire

struct OnboardingService {
    
    // 싱글톤 객체 생성
    static let shared = OnboardingService()
    
    func getOnboardingWithEmotionId (
        emotionId: Int,
        completion: @escaping (NetworkResult<Any>) -> Void
    ) {
        let url = APIConstants.sentencesURL + "/onboarding"
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": UserDefaults.standard.string(forKey: "token") ?? ""
        ]
        let body: Parameters = [
            "emotionId": "\(emotionId)"
        ]
        
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
                completion(judgeOnboardingWithEmotionIdData(status: statusCode, data: data))
                
            case .failure(let err): print(err)
                completion(.networkFail)
            }
        }
    }
    
    private func judgeOnboardingWithEmotionIdData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<OnboardingSentence>.self, from: data) else {
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
