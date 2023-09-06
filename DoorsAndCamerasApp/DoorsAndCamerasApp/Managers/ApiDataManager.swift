//
//  ApiDataManager.swift
//  DoorsAndCamerasApp
//
//  Created by sose yeritsyan on 23.08.23.
//

import Foundation

class ApiDataManager {
    
    static let shared = ApiDataManager()
    private init() {}
    
    func fetchData<T: Codable>(endpoint: Segments, responseType: T.Type, completion: @escaping (T?, Error?) -> Void) {
        
        guard let url = URL(string: "http://cars.cprogroup.ru/api/rubetek/\(endpoint.rawValue)") else {
            completion(nil, NSError(domain: "Invalid URL", code: -1, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
}
