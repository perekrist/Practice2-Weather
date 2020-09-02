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
    case serverError
    case parseError
}

struct Keys {
    static let query = "q"
    static let units = "units"
    static let appid = "appid"
}

extension ApiErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badCityError:
            return "Can't get weather for current city."
        case .serverError:
            return "Server side problems, try again later."
        case .parseError:
            return "Data parsing error."
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
                } catch {
                    completion(Swift.Result.failure(ApiErrors.parseError))
                    return
                }
            case .failure:
                guard let statusCode = response.response?.statusCode else {
                    completion(.failure(ApiErrors.serverError))
                    return
                }
                completion(.failure(self.classifyError(statusCode: statusCode)))
            }
        }
        
    }
    
    func getWeatherByCity(city: String, completion: @escaping (Swift.Result<Weather, Error>) -> Void) {
        let url = Constants.apiUrl
        
        let params = [
            Keys.query: city,
            Keys.units: R.string.weather.units(),
            Keys.appid: Api.key
        ]
        
        baseRequest(url: url, method: .get, params: params) { result in
            completion(result)
        }
    }
    
    private func classifyError(statusCode: Int) -> Error {
        switch statusCode {
        case 500...526:
            return ApiErrors.serverError
        default:
            return ApiErrors.badCityError
        }
    }
}
