//
//  NetworkClientTests.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 16/08/26.
//

import XCTest
@testable import NetworkingKit

final class NetworkClientTests: XCTestCase {
    
    private var configuration: NetworkConfiguration!
    private var endpoint: Endpoint!
    
    override func setUp() {
        super.setUp()
        configuration = NetworkConfiguration(baseURL: URL(string: "https://www.example.com")!)
        endpoint = TestEndpoint(path: "/api/v1/test")
    }
    
    // MARK: - Helper methods
    private func makeClient(statusCode: Int) -> NetworkClient {
        let httpResponse = HTTPURLResponse(url: URL(string: "https://www.example.com")!,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)!
        let mockExecutor = MockRequestExecutor(mockedResponse: httpResponse)
        return NetworkClient(executor: mockExecutor, configuration: configuration)
    }
    
    
    // MARK: -Successful response tests
    
    func test_send_successfulResponse_returnsCorrectStatusCode() async throws {
        let statusCode = 200
        let client = makeClient(statusCode: statusCode)
        
        let response = try await client.send(endpoint)
        
        XCTAssertEqual(response.statusCode, statusCode)
    }
    
    func test_send_successfulResponseUpperBoundary_returnsCorrectStatusCode() async throws {
        let statusCode = 299
        let client = makeClient(statusCode: statusCode)
        
        let response = try await client.send(endpoint)
        
        XCTAssertEqual(response.statusCode, statusCode)
    }
    
    // MARK: - Unsuccessful response tests
    
    func test_send_401StatusCode_throwsHttpErrorWithUnauthorizedCategory() async {
        let statusCode = 401
        let client = makeClient(statusCode: statusCode)
        
        do {
            _ = try await client.send(endpoint)
            XCTFail("Expected error to be thrown")
        } catch {
            switch error {
            case NetworkError.httpError(let statusCode, let category):
                XCTAssertEqual(statusCode, 401)
                XCTAssertEqual(category, .unauthorized)
            default:
                XCTFail("Expected HttpError with unauthorized category")
            }
        }
    }
    
    func test_send_403StatusCode_throwsHttpErrorWithForbiddenCategory() async {
        let statusCode = 403
        let client = makeClient(statusCode: statusCode)
        
        do {
            _ = try await client.send(endpoint)
            XCTFail("Expected error to be thrown")
        } catch {
            switch error {
            case NetworkError.httpError(let statusCode, let category):
                XCTAssertEqual(statusCode, 403)
                XCTAssertEqual(category, .forbidden)
            default:
                XCTFail("Expected HttpError with forbidden category")
            }
        }
    }
    
    func test_send_404StatusCode_throwsHttpErrorWithNotFoundCategory() async {
        let statusCode = 404
        let client = makeClient(statusCode: statusCode)
        
        do {
            _ = try await client.send(endpoint)
            XCTFail("Expected error to be thrown")
        } catch {
            switch error {
            case NetworkError.httpError(let statusCode, let category):
                XCTAssertEqual(statusCode, 404)
                XCTAssertEqual(category, .notFound)
            default:
                XCTFail("Expected HttpError with not found category")
            }
        }
    }
    
    func test_send_429StatusCode_throwsHttpErrorWithTooManyRequestsCategory() async {
        let statusCode = 429
        let client = makeClient(statusCode: statusCode)
        
        do {
            _ = try await client.send(endpoint)
            XCTFail("Expected error to be thrown")
        } catch {
            switch error {
            case NetworkError.httpError(let statusCode, let category):
                XCTAssertEqual(statusCode, 429)
                XCTAssertEqual(category, .tooManyRequests)
            default:
                XCTFail("Expected HttpError with too many requests category")
            }
        }
    }
    
    func test_send_500StatusCode_throwsHttpErrorWithServerErrorCategory() async {
        let statusCode = 500
        let client = makeClient(statusCode: statusCode)
        
        do {
            _ = try await client.send(endpoint)
            XCTFail("Expected error to be thrown")
        } catch {
            switch error {
            case NetworkError.httpError(let statusCode, let category):
                XCTAssertEqual(statusCode, 500)
                XCTAssertEqual(category, .serverError)
            default:
                XCTFail("Expected HttpError with server error category")
            }
        }
    }
    
    func test_send_599StatusCode_throwsHttpErrorWithServerErrorCategory() async {
        let statusCode = 599
        let client = makeClient(statusCode: statusCode)
        
        do {
            _ = try await client.send(endpoint)
            XCTFail("Expected error to be thrown")
        } catch {
            switch error {
            case NetworkError.httpError(let statusCode, let category):
                XCTAssertEqual(statusCode, 599)
                XCTAssertEqual(category, .serverError)
            default:
                XCTFail("Expected HttpError with server error category")
            }
        }
    }
    
    func test_send_unknownError_throwsHttpErrorWithUnknownCategory() async {
        let statusCode = 300
        let client = makeClient(statusCode: statusCode)
        
        do {
            _ = try await client.send(endpoint)
            XCTFail("Expected error to be thrown")
        } catch {
            switch error {
            case NetworkError.httpError(let statusCode, let category):
                XCTAssertEqual(statusCode, 300)
                XCTAssertEqual(category, .unknown)
            default:
                XCTFail("Expected HttpError with unknown category")
            }
        }
    }
    
    func test_send_urlResponse_throwsInvalidResponseError() async {
        let urlResponse = URLResponse()
        let mockExecutor = MockRequestExecutor(mockedResponse: urlResponse)
        let client = NetworkClient(executor: mockExecutor, configuration: configuration)
        
        do {
            _ = try await client.send(endpoint)
            XCTFail("Ecxpected error to be thrown")
        } catch {
            switch error {
            case NetworkError.invalidResponse:
                break
            default:
                XCTFail("Expected InvalidResponseError")
            }
        }
    }
    
    func test_send_timeoutError_throwsTimeoutError() async {
        let mockedError = URLError(.timedOut)
        let mockExecutor = MockRequestExecutor(mockedResponse: URLResponse(), mockedError: mockedError)
        let client = NetworkClient(executor: mockExecutor, configuration: configuration)
        
        do {
            _ = try await client.send(endpoint)
            XCTFail("Expected NetworkError.transport wrapping URLError(.timedOut)")
        } catch  {
            switch error {
            case NetworkError.transport(let error):
                XCTAssertEqual(error.code, .timedOut)
            default :
                XCTFail("Expected NetworkError.transport wrapping URLError(.timedOut)")
            }
        }
    }
}
