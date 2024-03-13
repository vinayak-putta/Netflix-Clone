//
//  HomeViewDataService.swift
//  Netflix Clone
//
//  Created by Vinayak Putta 13/01/24.
//

import Foundation

class HomeViewDataService {
    
    private let httpClient: HTTPClientProtocol
    private let dataDecoder: DataDecoder
    
    init(httpClient: HTTPClientProtocol, dataDecoder: DataDecoder) {
        self.httpClient = httpClient
        self.dataDecoder = dataDecoder
    }

    func getUpcomingMovies(pageCount: Int, completionHanlder: @escaping (Result<[Title], APIError>) -> Void) {
        var urlComponent = API.upComingMoviesURL
        urlComponent.queryItems?.append(.init(name: "page", value: String(pageCount)))
        
        fetch(with: urlComponent.url?.absoluteString, completionHanlder: completionHanlder)
    }
    
    func getTopRatedMovies(pageCount: Int, completionHanlder: @escaping (Result<[Title], APIError>) -> Void)  {
        var urlComponent = API.moviesURL
        urlComponent.path += "/top_rated"
        urlComponent.queryItems?.append(.init(name: "page", value: String(pageCount)))
        
        fetch(with: urlComponent.url?.absoluteString, completionHanlder: completionHanlder)
    }
    
    func getTrendingTvs(completionHanlder: @escaping (Result<[Title], APIError>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else { return }
        fetch(with: url.absoluteString, completionHanlder: completionHanlder)
    }

    func getTrendingMovies(completionHanlder: @escaping (Result<[Title], APIError>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else { return }
        fetch(with: url.absoluteString, completionHanlder: completionHanlder)
    }
    
    func getPopular(pageCount: Int, completionHanlder: @escaping (Result<[Title], APIError>) -> Void ) {
        var urlComponent = API.moviesURL
        urlComponent.path += "/popular"
        urlComponent.queryItems?.append(.init(name: "page", value: String(pageCount)))
        
        fetch(with: urlComponent.url?.absoluteString, completionHanlder: completionHanlder)
    }

    func getDiscoverMovies(completionHanlder: @escaping (Result<[Title], APIError>) -> Void ) {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        
        fetch(with: url.absoluteString, completionHanlder: completionHanlder)
    }

    private func fetch(with url: String?, completionHanlder: @escaping (Result<[Title], APIError>) -> Void) {
        NetworkManager.fetchData(with: httpClient, urlString: url) { [weak self] result in
            guard let self else {
                completionHanlder(.failure(.unknownError(description: "Something went wrong")))
                return
            }

            self.dataDecoder.decodeData(as: TrendingTitleResponse.self, for: result) { decodeDataResult in
                
                switch decodeDataResult {
                case .success(let data):
                    completionHanlder(.success(data.results))
                case .failure(let error):
                    completionHanlder(.failure(error))
                }
            }
        }
    }
}
