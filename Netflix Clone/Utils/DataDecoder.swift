//
//  DataDecoder.swift
//  Netflix Clone
//
//  Created by Vinayak Putta on 14/01/24.
//

import Foundation

class DataDecoder {
    func decodeData<T: Decodable>(as type: T.Type, for data: Data) throws -> T {
        return try JSONDecoder().decode(type, from: data)
    }
    
    func decodeData<T: Decodable>(
        as type: T.Type,
        for result: Result<Data, APIError>,
        completion: @escaping (Result<T, APIError>) -> Void) {
            
            switch result {
            case .success(let data):
                do {
                    let decodeData = try JSONDecoder().decode(type, from: data)
                    completion(.success(decodeData))
                } catch {
                    completion(.failure(.jsonParsing(description: error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
}



