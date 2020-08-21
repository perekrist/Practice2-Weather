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
}
