//
//  NetworkTypes.swift
//  CodingChallenge
//
//  Created by Aaron McDaniel on 8/15/22.
//

import Foundation

enum HttpMethod: String {
    case GET, POST, PATCH, DELETE
}

enum GoRestHttpRequestError: Error, Equatable {
    static func == (lhs: GoRestHttpRequestError, rhs: GoRestHttpRequestError) -> Bool {
        switch (lhs, rhs) {
        case (.networkTimeOut, .networkTimeOut),
            (.invalidUrl, .invalidUrl),
            (.dataError, .dataError):
            return true
        case (.serverError(let errorLHS, let messageLHS), .serverError(let errorRHS, let messageRHS)):
            if errorLHS?.localizedDescription == errorRHS?.localizedDescription && messageLHS == messageRHS {
                return true
            }

            return false
        default:
            return false
        }
    }

    case networkTimeOut

    case invalidUrl

    case serverError(error: Error?, message: String?)

    case dataError
}
