//
//  MockNetworkStore.swift
//  Netflix CloneTests
//
//  Created by Vinayak Putta on 14/01/24.
//

import Foundation

protocol NetworkStoreProtocol {
    func stub(url: String, for data: Data?)
    func makeRequest(with url: URL) -> (Data?, URLResponse?)
}

class MockNetworkStore: NetworkStoreProtocol {
    private var mockStore = [String: Data]()
    
    func stub(url: String, for data: Data?) {
        mockStore[url] = data
    }

    func makeRequest(with url: URL) -> (Data?, URLResponse?) {
        guard let data = getData(for: url.absoluteString) else {
            print("No data for url - \(url.absoluteString)")
            return (nil, responseCreator(with: url, statusCode: 404))
        }
        
        return (data, responseCreator(with: url, statusCode: 200))
    }

    private func getData(for url: String) -> Data? {
        return mockStore[url]
    }

    private func responseCreator(with url: URL, statusCode: Int) -> HTTPURLResponse? {
        return HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: url.scheme,
            headerFields: nil)
    }
}
