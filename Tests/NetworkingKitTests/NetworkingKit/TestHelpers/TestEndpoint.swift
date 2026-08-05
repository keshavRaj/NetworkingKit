//
//  TestEndPoint.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 04/08/26.
//

import Foundation
@testable import NetworkingKit

struct TestEndpoint: Endpoint {
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]
    
    init(path: String, method: HTTPMethod, queryItems: [URLQueryItem] = []) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
    }
}
