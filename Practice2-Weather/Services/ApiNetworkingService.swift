//
//  ApiNetworkingService.swift
//  Practice2-Weather
//
//  Created by Кристина Перегудова on 21.08.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import Foundation
import Alamofire

enum ApiErrors: Error {
    case badCityError
    case cityNotFound
    case serverError
}

extension ApiErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badCityError:
            return "Can't get weather for current city"
        case .cityNotFound:
            return "City not found"
        case .serverError:
            return "Ooups, there is some problems on the server side! Try again later."
        }
    }
}

class NetworkingService {
    public func baseRequest<T: Decodable>(url: String, method: HTTPMethod, params: Parameters?,
                                          completion: @escaping (Swift.Result<T, Error>) -> Void) {
        AF.request(url, method: method, parameters: params).responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
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
    
    func getWeatherByCity(city: String, completion: @escaping (Swift.Result<Weather, Error>) -> Void) {
        let url = Constants.apiUrl
        
        let params = [
            "q": city,
            "units": "metric",
            "appid": Api.key
        ]
        
        baseRequest(url: url, method: .get, params: params) { result in
            completion(result)
        }
    }
    
    private func handleError(statusCode: Int?) -> Error {
        guard let statusCode = statusCode else {
            return ApiErrors.badCityError
        }
        
        switch statusCode {
        case 400...499:
            return ApiErrors.cityNotFound
        case 500...526:
            return ApiErrors.serverError
        default:
            return ApiErrors.badCityError
        }
    }
}
