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
    
    // MARK:  -URL Tests
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
    
    func test_build_noQueryItems_doesNotAppendQueryItemsToURL() throws {
        let endpoint = TestEndpoint(path: path, method: .get)
        let request = try RequestBuilder.build(endpoint, baseURL: baseURL)
        XCTAssertEqual(request.url, URL(string: "https://leetcode.com/problems/permutation-string/history"))
    }
    
    // MARK: -HTTP methods tests
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
    
    // MARK: -Header Tests
    func test_build_appliesHeadersToRequest() throws {
        let headers: [String: String] = ["Authorization": "token", "Content-Type": "application/json"]
        let endpoint = TestEndpoint(path: path,method: .get, headers: headers)
        let request = try RequestBuilder.build(endpoint, baseURL: baseURL)
        XCTAssertEqual(request.allHTTPHeaderFields, headers)
    }
    
    // MARK: -Body Tests
    func test_build_noBody_doesNotCreateBodyToRequest() throws {
        let endpoint = TestEndpoint(path: path, method: .get)
        let request = try RequestBuilder.build(endpoint, baseURL: baseURL)
        XCTAssertNil(request.httpBody)
    }
    
    func test_build_encodesJSONBody() throws {
        let testUser = TestUser(age: 20, name: "Keshav")
        let requestBody = RequestBody.json(testUser)
        let endpoint = TestEndpoint(path: path, method: .post, body: requestBody)
        
        let request = try RequestBuilder.build(endpoint, baseURL: baseURL)
        
        let httpBody = try XCTUnwrap(request.httpBody)
        let decodedUser = try JSONDecoder().decode(TestUser.self, from: httpBody)
        
        XCTAssertEqual(decodedUser, testUser)
    }
    
    // MARK: -Error tests
    
    func test_build_invalidJsonBodyThrowsSerializationFailed() {
        let endpoint = TestEndpoint(path: path,
                                    method: .post,
                                    body: .json(FailingEncodable()))
        XCTAssertThrowsError(
            try RequestBuilder.build(endpoint, baseURL: baseURL)) { error in
                switch error {
                case NetworkError.serializationFailed(let serializationError):
                    guard let encodingError = serializationError as? FailingEncodable.TestError else {
                        XCTFail("Expected FailingEncodable.TestError")
                        return
                    }
                    XCTAssertEqual(encodingError, .intentionalFail)
                default :
                    XCTFail("Expected serializationFailed error")
                }
            }
    }
    
    func test_build_invalidURLThrowsInvalidURL() {
        let endPoint = TestEndpoint(path: "hello")
        XCTAssertThrowsError(
            try RequestBuilder.build(endPoint, baseURL: baseURL)) { error in
                switch error {
                case NetworkError.invalidURL:
                    break
                default :
                    XCTFail("Expected invalidURL error")
                }
            }
    }
}
