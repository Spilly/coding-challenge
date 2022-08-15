//
//  GoRestHttpRequestErrorTests.swift
//  CodingChallengeTests
//
//  Created by Aaron McDaniel on 8/15/22.
//

import XCTest

@testable import CodingChallenge

struct TestError: Error {}

class GoRestHttpRequestErrorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEquality() throws {
        XCTAssertEqual(GoRestHttpRequestError.dataError, .dataError)
        XCTAssertEqual(GoRestHttpRequestError.invalidUrl, .invalidUrl)
        XCTAssertEqual(GoRestHttpRequestError.networkTimeOut, .networkTimeOut)
        XCTAssertNotEqual(GoRestHttpRequestError.dataError, .invalidUrl)

        let serverError = TestError()
        let serverGoRestHttpRequestError = GoRestHttpRequestError.serverError(error: serverError, message: "ERROR")
        XCTAssertEqual(serverGoRestHttpRequestError, serverGoRestHttpRequestError)


        let newServerGoRestHttpRequestError = GoRestHttpRequestError.serverError(error: serverError, message: "INEQUAL")
        XCTAssertNotEqual(serverGoRestHttpRequestError, newServerGoRestHttpRequestError)
    }

}
