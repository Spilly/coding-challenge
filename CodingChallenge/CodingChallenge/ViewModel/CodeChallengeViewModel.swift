//
//  CodeChallengeViewModel.swift
//  CodingChallenge
//
//  Created by Aaron McDaniel on 8/15/22.
//

import Foundation
import CocoaLumberjack

enum CodeChallengeState {
    case notStarted,
         retrievePageThree,
         sortUserList,
         logLastUser,
         updateUsersName,
         deleteUser,
         retrieveInvalidUser,
         finishedSuccessfully,
         finishedWithError

    func displayText() -> String {
        switch self {

        case .notStarted:
            return "Not started"
        case .retrievePageThree:
            return "Retrieve page 3 of the list of all users and log the total number of pages"
        case .sortUserList:
            return "Sort the retrieved user list by name"
        case .logLastUser:
            return "Log the name of the last user."
        case .updateUsersName:
            return "Update that user's name to a new value and use the correct http method to save it."
        case .deleteUser:
            return "Delete that user"
        case .retrieveInvalidUser:
            return "Attempt to retrieve a nonexistent user with ID 5555"
        case .finishedSuccessfully:
            return "Finished Successfully"
        case .finishedWithError:
            return "Finished with errors"
        }
    }
}

class CodeChallengeViewModel: ObservableObject {
    private let sessionConfig = URLSessionConfiguration.default
    @Published var codeChallengeState = CodeChallengeState.notStarted

    init() {
        sessionConfig.httpAdditionalHeaders = [ "Accept" : "application/json",
                                                "Content-Type" : "application/json",
                                                "Authorization" : "Bearer e2de6944b6aac2e4186a9a28d5ca574c30033ce96b7a6c186d7e09579ebf79dc"]
    }

    func runCodingChallenge() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            DDLogInfo("Begin Coding Challenge")

            self.updateCodeChallengeState(.retrievePageThree)
            let session = URLSession(configuration: self.sessionConfig)
            let goRestClient = NetworkClient(networkTimeout: 5.0, session: session)

            // Retrieve page 3 of the list of all users and log the total number of pages from the previous request.
            let result = goRestClient.getUsers(page: 3)

            if case let .success(users) = result {
                // Sort the retrieved user list by name.
                self.updateCodeChallengeState(.sortUserList)
                let sortedUsers = users.sorted { $0.name < $1.name }

                if let lastUser = sortedUsers.last {
                    // Log the name of the last user.
                    self.updateCodeChallengeState(.logLastUser)
                    DDLogInfo("Last user's name: \(lastUser.name)")

                    // Update that user's name to a new value and use the correct http method to save it.
                    self.updateCodeChallengeState(.updateUsersName)
                    let updateUser = User(id: lastUser.id, name: "Aaron Smith", email: lastUser.email, gender: lastUser.gender, status: .active)
                    _ = goRestClient.updateUser(updateUser)

                    // Delete that user.
                    self.updateCodeChallengeState(.deleteUser)
                    //let deletedUser = goRestClient.deleteUser(lastUser)

                    // Attempt to retrieve a nonexistent user with ID 5555
                    self.updateCodeChallengeState(.retrieveInvalidUser)
                    let nonexistentID: Int = 5555
                    let errorResponse = goRestClient.getUser(id: nonexistentID)

                    // Log the resulting http response code.
                    if case let .failure(genericError) = errorResponse, case let .serverError(_, message) = genericError {
                        if let message = message {
                            DDLogError("Http Response: \(message)")
                        }
                    }

                    self.updateCodeChallengeState(.finishedSuccessfully)
                    return
                }
            }

            self.updateCodeChallengeState(.finishedWithError)
            DDLogInfo("End of Coding Challenge")
        }
    }

    private func updateCodeChallengeState(_ state: CodeChallengeState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.codeChallengeState = state
        }
    }
}
