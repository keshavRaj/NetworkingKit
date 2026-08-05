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
    let headers: [String : String]
    let body: RequestBody
    
    init(path: String,
         method: HTTPMethod = .get,
         queryItems: [URLQueryItem] = [],
         headers: [String : String] = [:],
         body: RequestBody = .none) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
    }
}
