//
//  UpcomingViewControllerDataService.swift
//  Netflix Clone
//
//  Created by Vinayak Putta on 13/01/24.
//

import Foundation

class UpcomingMoviesDataService {
    
    private let httpClient: HTTPClientProtocol
    private let dataDecoder: DataDecoder
    
    init(httpClient: HTTPClientProtocol, dataDecoder: DataDecoder) {
        self.httpClient = httpClient
        self.dataDecoder = dataDecoder
    }

    func getUpcomingMovies(pageCount: Int, completionHanlder: @escaping (Result<TrendingTitleResponse, APIError>) -> Void) {
        var urlComponent = API.upComingMoviesURL
        urlComponent.queryItems?.append(.init(name: "page", value: String(pageCount)))
        
        NetworkManager.fetchData(with: httpClient, urlString: urlComponent.url?.absoluteString) { [weak self] result in
            guard let self else {
                completionHanlder(.failure(.unknownError(description: "Something went wrong")))
                return
            }
    
            self.dataDecoder.decodeData(as: TrendingTitleResponse.self, for: result) { decodeDataResult in
                completionHanlder(decodeDataResult)
            }
        }
    }
}
