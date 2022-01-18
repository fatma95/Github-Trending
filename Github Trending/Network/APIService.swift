//
//  APIService.swift
//  Github Trending
//
//  Created by Fatma Mohamed on 17/01/2022.
//

import Foundation
import Alamofire

class APIService {
    private init() {}
    static let instance = APIService()
    func getData<T: Decodable>(url: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, completion: @escaping (T?, Error?)->()) {
        
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate(statusCode: 200...300)
            .response { (response) in
                switch response.result {
                case .success(_):
                    guard let data = response.data else { return }
                    do {
                        let jsonData = try JSONDecoder().decode(T.self, from: data)
                        completion(jsonData, nil)
                    }
                    catch let jsonError {
                        print(jsonError)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
            }
        
        
    }
}
}
