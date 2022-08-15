//
//  NetworkClient.swift
//  CodingChallenge
//
//  Created by Aaron McDaniel on 8/12/22.
//

import Foundation
import CocoaLumberjack

class NetworkClient: GoRestHttpRequestProtocol {

    var networkTimeout: TimeInterval
    private var session: NetworkSession

    init(networkTimeout: TimeInterval, session: NetworkSession) {
        DDLog.add(DDOSLogger.sharedInstance)

        self.networkTimeout = networkTimeout
        self.session = session
    }

    func getUser(id: Int) -> Result<User, GoRestHttpRequestError> {
        let urlRequest = URLRequest(url: Endpoint.user(id: id).url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: networkTimeout)
        let result = makeRequest(urlRequest)

        switch result {
        case .success(let data):
            if let jsonData = data {
                let user = try! JSONDecoder().decode(User.self, from: jsonData)
                return .success(user)
            }

            return .failure(.dataError)
        case .failure(let error):
            DDLogError("Failed to get user of id \(id)")
            return .failure(error)
        }
    }

    func getUser(_ user: User) -> Result<User, GoRestHttpRequestError> {
        return getUser(id: user.id)
    }

    func getUsers(page: Int) -> Result< [User], GoRestHttpRequestError> {
        let urlRequest = URLRequest(url: Endpoint.users(page: page).url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: networkTimeout)
        let result = makeRequest(urlRequest)

        switch result {
        case .success(let data):
            if let jsonData = data {
                let users = try! JSONDecoder().decode([User].self, from: jsonData)
                return .success(users)
            }

            return .failure(.dataError)
        case .failure(let error):
            DDLogError("Failed to get users from page \(page)")
            return .failure(error)
        }
    }

    func updateUser(_ user: User) -> Result< User, GoRestHttpRequestError> {
        var urlRequest = URLRequest(url: Endpoint.user(id: user.id).url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: networkTimeout)
        urlRequest.httpMethod = HttpMethod.PATCH.rawValue

        do {
            let encodedResult = try JSONEncoder().encode(user)
            print(encodedResult.debugDescription)

            urlRequest.httpBody = encodedResult
        } catch let error {
            DDLogError("Failed to encode user JSON because \(error.localizedDescription)")
        }

        let result = makeRequest(urlRequest)

        switch result {
        case .success(let data):
            if let jsonData = data {
                let user = try! JSONDecoder().decode(User.self, from: jsonData)
                return .success(user)
            }

            return .failure(.dataError)
        case .failure(let error):
            DDLogError("Failed to update user \(user.id)")
            return .failure(error)
        }
    }

    func deleteUser(_ user: User) -> Result< User, GoRestHttpRequestError> {
        return deleteUser(id: user.id)
    }

    func deleteUser(id: Int) -> Result<User, GoRestHttpRequestError> {
        var urlRequest = URLRequest(url: Endpoint.user(id: id).url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: networkTimeout)
        urlRequest.httpMethod = HttpMethod.DELETE.rawValue

        let result = makeRequest(urlRequest)

        switch result {
        case .success(let data):
            if let jsonData = data {
                let user = try! JSONDecoder().decode(User.self, from: jsonData)
                return .success(user)
            }

            return .failure(.dataError)
        case .failure(let error):
            DDLogError("Failed to delete user \(id)")
            return .failure(error)
        }
    }

    private func makeRequest(_ urlRequest: URLRequest) -> Result< Data?, GoRestHttpRequestError> {
        var returnData: Data?
        var returnError: GoRestHttpRequestError?
        let semaphore = DispatchSemaphore(value: 0)

        session.loadData(from: urlRequest) { data, response, error in
            if let error = error {
                returnError = error._code == URLError.timedOut.rawValue ? .networkTimeOut : .serverError(error: error, message: nil)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode >= 400 {
                    returnError = .serverError(error: nil, message: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                } else if let jsonData = data {
                    if let totalPages = httpResponse.allHeaderFields["x-pagination-pages"] {
                        DDLogInfo("Total pages: \(totalPages)")
                    }

                    returnData = jsonData
                }
            }

            semaphore.signal()
        }

        semaphore.wait()

        if let returnError = returnError {
            return .failure(returnError)
        }

        return .success(returnData)
    }
}
