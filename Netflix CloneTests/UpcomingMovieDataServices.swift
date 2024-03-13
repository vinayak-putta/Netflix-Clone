//
//  UpcomingMovieDataServices.swift
//  Netflix CloneTests
//
//  Created by Vinayak Putta on 15/02/24.
//

import XCTest
@testable import Netflix_Clone

final class UpcomingMovieDataServices: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testfetchUpcomingMovies() {
        let urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=697d439ac993538da4e3e60b54e762cd&language=en-US&page=1"
        let networkStore = MockNetworkStore()
        networkStore.stub(url: urlString, for: MovieModel.mock)
        let mockClient = MockHTTPClient(networkStore: networkStore)
        let decoder = DataDecoder()
        let dataService = UpcomingMoviesDataService(httpClient: mockClient, dataDecoder: decoder)

        let expectation = XCTestExpectation(description: "UpcomingMoviesDataService fetched movies list")

        dataService.getUpcomingMovies(pageCount: 1) { result in
            switch result {
            case .success(let data):
                XCTAssertTrue(data.results.count > 0)
            case .failure(let error):
                XCTFail("Error should be nil: - \(error.apiErrorString)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation])
    }

}

