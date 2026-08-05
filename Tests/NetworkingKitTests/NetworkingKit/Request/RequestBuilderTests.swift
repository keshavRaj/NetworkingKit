//
//  RequestBuilderTests.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 04/08/26.
//

import XCTest
import Foundation
@testable import NetworkingKit
final class RequestBuilderTests: XCTestCase {
    private var path: String!
    private var baseURL: URL!
    
    override func setUp() {
        super.setUp()
        path = "/problems/permutation-string/history"
        baseURL = URL(string: "https://leetcode.com")!
    }
    
    func test_build_returnsURLRequestForValidEndpoint() throws {
        let endpoint = TestEndpoint(path: path, method: .get)
        let request = try RequestBuilder.build(endpoint, baseURL: baseURL)
        XCTAssertEqual(request.url, URL(string: "https://leetcode.com/problems/permutation-string/history"))
    }
    
    func test_build_removesTrailingSlashFromBaseURL() throws {
        let baseURL = URL(string: "https://leetcode.com/")!
        let endpoint = TestEndpoint(path: path, method: .get)
        let request = try RequestBuilder.build(endpoint, baseURL: baseURL)
        XCTAssertEqual(request.url, URL(string: "https://leetcode.com/problems/permutation-string/history"))
    }
    
    func test_build_appendsQueryItemsToURL() throws {
        let endpoint = TestEndpoint(path: path,
                                    method: .get,
                                    queryItems: [URLQueryItem(name: "page", value: "1"),
                                                 URLQueryItem(name: "limit", value: "20")])
        let request = try RequestBuilder.build(endpoint, baseURL: baseURL)
        XCTAssertEqual(request.url, URL(string: "https://leetcode.com/problems/permutation-string/history?page=1&limit=20"))
    }
    
    func test_build_appliesGETMethodToRequest() throws {
        let endpoint = TestEndpoint(path: path, method: .get)
        let request = try RequestBuilder.build(endpoint, baseURL: baseURL)
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func test_build_appliesPOSTMethodToRequest() throws {
        let endpoint = TestEndpoint(path: path, method: .post)
        let request = try RequestBuilder.build(endpoint, baseURL: baseURL)
        XCTAssertEqual(request.httpMethod, "POST")
    }
    
    func test_build_appliesPUTMethodToRequest() throws {
        let endpoint = TestEndpoint(path: path, method: .put)
        let request = try RequestBuilder.build(endpoint, baseURL: baseURL)
        XCTAssertEqual(request.httpMethod, "PUT")
    }
    
    func test_build_appliesDELETEMethodToRequest() throws {
        let endpoint = TestEndpoint(path: path, method: .delete)
        let request = try RequestBuilder.build(endpoint, baseURL: baseURL)
        XCTAssertEqual(request.httpMethod, "DELETE")
    }
    
    func test_build_appliesPATCHMethodToRequest() throws {
        let endpoint = TestEndpoint(path: path, method: .patch)
        let request = try RequestBuilder.build(endpoint, baseURL: baseURL)
        XCTAssertEqual(request.httpMethod, "PATCH")
    }
}
