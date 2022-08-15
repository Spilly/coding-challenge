//
//  User.swift
//  CodingChallenge
//
//  Created by Aaron McDaniel on 8/12/22.
//

import Foundation

enum Gender: String, Codable {
    case male, female
}

enum Status: String, Codable {
    case active, inactive
}

struct User: Codable, Equatable {
    let id: Int
    let name: String
    let email: String
    let gender: Gender
    let status: Status
}
