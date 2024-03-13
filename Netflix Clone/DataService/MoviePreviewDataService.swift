//
//  MoviePreviewDataService.swift
//  Netflix Clone
//
//  Created by Vinayak Putta on 13/01/24.
//

import Foundation

class MoviePreviewDataService {
    
    private let httpClient: HTTPClientProtocol
    private let dataDecoder: DataDecoder
    
    init(httpClient: HTTPClientProtocol, dataDecoder: DataDecoder) {
        self.httpClient = httpClient
        self.dataDecoder = dataDecoder
    }

    func getMovie(with title: Title, completionHandler: @escaping (Result<TitlePreviewViewModel, APIError>) -> Void) {
        
        guard let titleName = title.original_title ?? title.original_name else {
            completionHandler(.failure(.unknownError(description: "Empty title")))
            return
        }

        guard let query = titleName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }

        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else { return }
        
        NetworkManager.fetchData(with: httpClient, urlString: url.absoluteString) { [weak self] result in
            guard let self else {
                completionHandler(.failure(.unknownError(description: "Something went wrong")))
                return
            }

            self.dataDecoder.decodeData(as: YoutubeSearchResponse.self, for: result) { decodeDataResult in
                
                switch decodeDataResult {
                case .success(let data):
                    if let videoElement = data.items.first {
                        let model = self.previewModel(from: title, videoElement: videoElement)
                        completionHandler(.success(model))
                    } else {
                        completionHandler(.failure(.unknownError(description: "Empty response")))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }

    func previewModel(from title: Title, videoElement: VideoElement) -> TitlePreviewViewModel {
        return TitlePreviewViewModel(
            title: title.original_title ?? "No title",
            youtubeView: videoElement,
            titleOverview: title.overview ?? "No Description")
    }
    
}
