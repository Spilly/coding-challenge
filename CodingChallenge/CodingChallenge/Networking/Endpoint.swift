//
//  Endpoint.swift
//  CodingChallenge
//
//  Created by Aaron McDaniel on 8/13/22.
//

import Foundation

enum Endpoint {
    case user(id: Int)
    case users(page: Int)

    var url: URL? {
        switch self {
        case .user(let id):
            return .makeForEndpoint("users/\(id)")
        case .users(let page):
            return .makeForEndpoint("users?page=\(page)")
        }
    }
}

private extension URL {
    static func makeForEndpoint(_ endpoint: String) -> URL? {
        return URL(string: "https://gorest.co.in/public/v2/\(endpoint)")
    }
}

