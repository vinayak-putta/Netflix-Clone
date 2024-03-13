//
//  APIError.swift
//  Netflix Clone
//
//  Created by Vinayak Putta on 13/01/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case unknownError(description: String)
    case responseError(description: String)
    case invalidStatusCode(statusCode: Int)
    case jsonParsing(description: String)

    var apiErrorString: String {
        switch self {
        case .invalidURL:
            return "Invalid url is being sent"
        case .unknownError(description: let description):
            return "Unknown Error: \(description)"
        case .responseError(description: let description):
            return "Response Error: \(description)"
        case .invalidStatusCode(statusCode: let statusCode):
            return handleStatusCode(statusCode)
        case .jsonParsing(description: let description):
            return "json parsing Error: \(description)"
        }
    }

    private func handleStatusCode(_ statusCodeValue: Int) -> String {
        let statusCode = HTTPStatusCode(rawValue: statusCodeValue)
        let statusCodeString = "Status Code: \(statusCodeValue)"
        switch statusCode {
        case .success:
            return "\(statusCodeString) - request success"
        case .notFound:
            return "\(statusCodeString) - request not found"
        case .badRequest:
            return "\(statusCodeString) - bad request"
        case .internalServerError:
            return "\(statusCodeString) - internal server Error"
        default:
            return "\(statusCodeString) - currently not handling"
        }
    }

}

enum HTTPStatusCode: Int {
    // Success
    case success = 200
    case created = 201
    case accepted = 202

    // Redirection
    case movedPermanently = 301
    case found = 302
    case seeOther = 303

    // Client Error
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404

    // Server Error
    case internalServerError  = 500
    case notImplemented = 501
    case badGateway = 502
}

