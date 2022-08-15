//
//  CodingChallengeRunthrough.swift
//  CodingChallengeRunthrough
//
//  Created by Aaron McDaniel on 8/11/22.
//

import XCTest
import CocoaLumberjack
@testable import CodingChallenge


class CodingChallengeRunthrough: XCTestCase {

    private let sessionConfig = URLSessionConfiguration.default

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        DDLog.add(DDOSLogger.sharedInstance)

        sessionConfig.httpAdditionalHeaders = [ "Accept" : "application/json",
                                                "Content-Type" : "application/json",
                                                "Authorization" : "Bearer e2de6944b6aac2e4186a9a28d5ca574c30033ce96b7a6c186d7e09579ebf79dc"]
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCodingExecise() {

    }

//    func testCodingChallenge() throws {
//        DDLogInfo("Begin Coding Challenge")
//
//        let session = URLSession(configuration: sessionConfig)
//        let goRestClient = NetworkClient(networkTimeout: 5.0, session: session)
//
//        // 1. Retrieve page 3 of the list of all users
//        // 2. log the total number of pages from the previous request.
//        let result = goRestClient.getUsers(page: 3)
//
//        if case let .success(users) = result {
//            // 3. Sort the retrieved user list by name.
//            let sortedUsers = users.sorted { $0.name < $1.name }
//
//            if let lastUser = sortedUsers.last {
//                // 4. Log the name of the last user.
//                DDLogInfo("Last user's name: \(lastUser.name)")
//
//                // 5. Update that user's name to a new value and use the correct http method to save it.
//                let updateUser = User(id: lastUser.id, name: "Aaron Smith", email: lastUser.email, gender: lastUser.gender, status: .active)
//                _ = goRestClient.updateUser(updateUser)
//
//                // 6. Delete that user.
//                //let deletedUser = goRestClient.deleteUser(lastUser)
//
//                // 7. Attempt to retrieve a nonexistent user with ID 5555. Log the resulting http response code.
//                let nonexistentID: Int = 5555
//                _ = goRestClient.getUser(id: nonexistentID)
//            }
//        }
//
//        DDLogInfo("End of Coding Challenge")
//    }

}
