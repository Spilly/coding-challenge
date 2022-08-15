//
//  NetworkSession.swift
//  CodingChallenge
//
//  Created by Aaron McDaniel on 8/15/22.
//

import Foundation

protocol NetworkSession {
    func loadData(from url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}
