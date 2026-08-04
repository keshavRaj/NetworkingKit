//
//  RequestBuilderTests.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 04/08/26.
//

import XCTest
@testable import NetworkingKit
final class RequestBuilderTests: XCTestCase {
    
    private var endpoint: TestEndpoint!
    private var baseURL: URL!
    
    override func setUp()  {
        let path = "/problems/permutation-string/history"
        baseURL = URL(string: "https://leetcode.com")!
        endpoint = TestEndpoint(path: path, method: .get)
    }
    
    func test_build_returnsURLRequestForValidEndpoint() throws {
        let request = try RequestBuilder.build(endpoint, baseURL: baseURL)
        XCTAssertEqual(request.url, URL(string: "https://leetcode.com/problems/permutation-string/history"))
    }

}
