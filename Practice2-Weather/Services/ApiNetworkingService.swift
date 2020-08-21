//
//  ApiNetworkingService.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 21.08.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import Foundation
import Alamofire

class ApiNetworkingService {
    func getWeatherByCity(city: String, completion: @escaping (Swift.Result<Weather, Error>) -> Void) {
        let url = Constants.apiUrl
        
        let params = [
            "q": city,
            "units": "metric",
            "APPID": Api.key
        ]
        
        AF.request(url, method: .get, parameters: params).responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(Weather.self, from: data)
                    completion(Swift.Result.success(decodedData))
                    
                } catch let error {
                    completion(Swift.Result.failure(error))
                    return
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
}
