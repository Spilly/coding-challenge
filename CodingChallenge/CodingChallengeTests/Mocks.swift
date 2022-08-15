//
//  Mocks.swift
//  CodingChallengeTests
//
//  Created by Aaron McDaniel on 8/15/22.
//

import Foundation

@testable import CodingChallenge

class NetworkSessionMock: NetworkSession {

    var data: Data?
    var error: Error?
    var response: URLResponse?

    func loadData(from url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completionHandler(data, response, error)
    }
}
