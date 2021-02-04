//
//  DiariesStatistics.swift
//  MoMo
//
//  Created by 이정엽 on 2021/02/03.
//

import Foundation
import Alamofire

//통계를 위한 함수

struct DiaryStatistics {
    static let shared = DiaryStatistics()
    
    // get
    func getDiaryStatistics(userId: String,
                            year: String,
                            month: String,
                            completion: @escaping (NetworkResult<Any>) -> (Void)) {
        let url = APIConstants.statisticsURL
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": UserDefaults.standard.string(forKey: "token") ?? ""
        ]
        
        let body: Parameters = [
            "userId": userId,
            "year": year,
            "month": month
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
                completion(judgeDiaryStatisticsData(status: statusCode, data: data))
            
            case .failure(let err):
                completion(.networkFail)
            }
        }
    }
    
    private func judgeDiaryStatisticsData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<Statistics>.self,
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
