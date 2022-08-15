//
//  NetworkClientTests.swift
//  CodingChallengeTests
//
//  Created by Aaron McDaniel on 8/15/22.
//

import XCTest

@testable import CodingChallenge

class NetworkClientTests: XCTestCase {
    let stubUserId = 555
    let stubUser = User(id: 123, name: "Aaron Smith", email: "aaron.smith@gmail.com", gender: .male, status: .active)
    let secondStubUser = User(id: 234, name: "Beth Peter", email: "bob.adams@gmail.com", gender: .female, status: .inactive)
    lazy var stubUsers: [User] = [stubUser, secondStubUser]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetUser() throws {
        let mockGetUserCall = NetworkSessionMock()

        do {
            let encodedResult = try JSONEncoder().encode(stubUser)
            mockGetUserCall.data = encodedResult
        } catch let error {
            print("Error encoding the User data, ensur User object conforms to the codable protocol")
        }

        mockGetUserCall.response = HTTPURLResponse(url: Endpoint.user(id: stubUser.id).url, statusCode: 200, httpVersion: nil, headerFields: nil)

        let mockRestClient = NetworkClient(networkTimeout: 5.0, session: mockGetUserCall)
        let response = mockRestClient.getUser(stubUser)

        if case let .success(user) = response {
            XCTAssertEqual(user, stubUser)
        } else {
            XCTFail("Didn't get user back")
        }
    }

    func testGetUserStatusError() throws {
        let mockGetUserCall = NetworkSessionMock()
        mockGetUserCall.response = HTTPURLResponse(url: Endpoint.user(id: stubUserId).url, statusCode: 404, httpVersion: nil, headerFields: nil)

        let mockRestClient = NetworkClient(networkTimeout: 5.0, session: mockGetUserCall)
        let response = mockRestClient.getUser(id: stubUserId)

        if case let .success(user) = response {
            XCTFail("Shouldn't succeed when getting 404 back from the endpoint")
        } else if case let .failure(error) = response {
            if case let .serverError(serverError, message) = error {
                XCTAssertNil(serverError)
                XCTAssertEqual(message, "not found")
            }
        }
    }

    func testGetUserTimeoutError() throws {
        let mockGetUserCall = NetworkSessionMock()
        mockGetUserCall.error = URLError(.timedOut)

        let mockRestClient = NetworkClient(networkTimeout: 5.0, session: mockGetUserCall)
        let response = mockRestClient.getUser(id: stubUserId)

        if case let .success(user) = response {
            XCTFail("Shouldn't succeed when getting 404 back from the endpoint")
        } else if case let .failure(error) = response {
            XCTAssertEqual(error, .networkTimeOut)
        }
    }

}