//
//  API.swift
//  Netflix Clone
//
//  Created by Vinayak Putta on 14/01/24.
//

import Foundation

struct Constants {
    static let API_KEY = "697d439ac993538da4e3e60b54e762cd"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyDqX8axTGeNpXRiISTGL7Tya7fjKJDYi4g"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

struct API {

    static var baseURL: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3"
        
        return components
    }
    
    static var moviesURL: URLComponents {
        var upcomingMoviesURComponents = API.baseURL
        upcomingMoviesURComponents.path += "/movie"
        upcomingMoviesURComponents.queryItems = [
            .init(name: "api_key", value: Constants.API_KEY),
            .init(name: "language", value: "en-US"),
        ]

        return upcomingMoviesURComponents
    }

    static var upComingMoviesURL: URLComponents {
        var upcomingMoviesURComponents = API.baseURL
        upcomingMoviesURComponents.path += "/movie/upcoming"
        upcomingMoviesURComponents.queryItems = [
            .init(name: "api_key", value: Constants.API_KEY),
            .init(name: "language", value: "en-US"),
        ]

        return upcomingMoviesURComponents
    }
}

