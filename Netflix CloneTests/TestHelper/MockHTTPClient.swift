//
//  MockHTTPClient.swift
//  Netflix CloneTests
//
//  Created by Vinayak Putta on 14/01/24.
//

import Foundation

@testable import Netflix_Clone

class MockHTTPClient: HTTPClientProtocol {
    let networkStore: NetworkStoreProtocol
    
    init(networkStore: NetworkStoreProtocol) {
        self.networkStore = networkStore
    }
    
    func dataTaskWrapper(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTClientDataTaskProtocol {
        let task = MockURLSessionDataTask()
        let (data, response) = networkStore.makeRequest(with: url)
        
        task.completionHander = {
            if data == nil && response == nil {
                let error = NSError()
                completionHandler(data, response, error)
            }
            completionHandler(data, response, nil)
        }
        return task
    }
}

class MockURLSessionDataTask: HTTClientDataTaskProtocol {
    var completionHander: (() -> ())?
    
    func resume() {
        completionHander?()
    }
}


