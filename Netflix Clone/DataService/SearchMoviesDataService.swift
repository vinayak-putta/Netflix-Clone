//
//  SearchMoviesDataService.swift
//  Netflix Clone
//
//  Created by Vinayak Putta on 12/03/24.
//

import Foundation

class SearchMoviesDataService {
    
    private let httpClient: HTTPClientProtocol
    private let dataDecoder: DataDecoder
    
    init(httpClient: HTTPClientProtocol, dataDecoder: DataDecoder) {
        self.httpClient = httpClient
        self.dataDecoder = dataDecoder
    }
    
    func getDiscoverMovies(completionHanlder: @escaping (Result<[Title], APIError>) -> Void ) {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        
        fetch(with: url.absoluteString, completionHanlder: completionHanlder)
    }
            
    func search(with queyString: String, completionHanlder: @escaping (Result<[Title], APIError>) -> Void) {
        guard let query = queyString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
            return
        }
        
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
