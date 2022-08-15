//
//  GoRestHttpRequestProtocol.swift
//  CodingChallenge
//
//  Created by Aaron McDaniel on 8/15/22.
//

import Foundation

protocol GoRestHttpRequestProtocol {
    var networkTimeout: TimeInterval { get set }

    func getUsers(page: Int) -> Result< [User], GoRestHttpRequestError>

    func getUser(id: Int) -> Result< User, GoRestHttpRequestError>
    func getUser(_ user: User) -> Result< User, GoRestHttpRequestError>

    func updateUser(_ user: User) -> Result< User, GoRestHttpRequestError>

    func deleteUser(_ user: User) -> Result< User, GoRestHttpRequestError>
}
