//
//  NetworkHandler.swift
//  Netflix Clone
//
//  Created by Vinayak Putta 13/01/24.
//

import Foundation


final class NetworkManager {
    
    // MARK: - Public methods
    
    /**
     Fetch data using completion handler
     **/
    static func fetchData(with httpClient: HTTPClientProtocol, urlString: String?, completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let urlString,
              let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        let dataTask = httpClient.dataTaskWrapper(with: url) { data, response, error in
            // resolve error
            if let error {
                completion(.failure(.unknownError(description: error.localizedDescription)))
                return
            }
            
            do {
                // validate response
                try validateResponse(response)
            } catch {
                if let apiError = error as? APIError {
                    completion(.failure(apiError))
                    return
                } else {
                    completion(.failure(.unknownError(description: error.localizedDescription)))
                    return
                }
            }
            
            // Check data
            guard let data else {
                completion(.failure(APIError.unknownError(description: "Data cannot be nil")))
                return
            }
            completion(.success(data))
        }
        
        dataTask.resume()
    }
   
   // MARK: - Private helpers
    
    private static func validateResponse(_ response: URLResponse?) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.responseError(description: "Failed to cast response to HTTPURLResponse")
        }
        let validRange = (200..<300)
        if !validRange.contains(httpResponse.statusCode)  {
            throw APIError.invalidStatusCode(statusCode: httpResponse.statusCode)
        }
    }
}

