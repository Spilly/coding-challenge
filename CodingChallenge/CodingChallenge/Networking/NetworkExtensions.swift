//
//  NetworkExtensions.swift
//  CodingChallenge
//
//  Created by Aaron McDaniel on 8/15/22.
//

import Foundation

extension URLSession: NetworkSession {
    func loadData(from urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = dataTask(with: urlRequest) { (data, response, error) in
            completionHandler(data, response, error)
        }

        task.resume()
    }
}


