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
    
    // MARK: - Empty Response
    
    // MARK: -Successful responses
    
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
    
    func test_send_statusCode204_returnsCorrectStatusCode() async throws {
        let statusCode = 204
        let client = makeClient(statusCode: statusCode)
        
        let response = try await client.send(endpoint)
        
        XCTAssertEqual(response.statusCode, statusCode)
    }
    
    // MARK: - HTTP Errors
    
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
  
    // MARK: - Response Errors
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
    
    // MARK: - Transport Errors
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
    
    // MARK: - Decodable Responses
    // MARK: - Successful Responses
    
    func test_send_decodableResponse_decodesResponse() async throws {
        let urlResponse = HTTPURLResponse(url: URL(string: "https://www.example.com")!,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: ["Content-Type": "application/json"])!
        let testUser = TestUser(age: 1, name: "test")
        let data = try JSONEncoder().encode(testUser)
        let mockExecutor = MockRequestExecutor(mockedData: data,
                                               mockedResponse: urlResponse)
        let client = NetworkClient(executor: mockExecutor, configuration: configuration)
        
        let response: NetworkResponse<TestUser> = try await client.send(endpoint)
        XCTAssertEqual(response.value, testUser)
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(response.contentType, "application/json")
    }
    
    func test_send_contentTypeWithCharset_acceptsExpectedContentType() async throws {
        let urlResponse = HTTPURLResponse(url: URL(string: "https://www.example.com")!,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: ["Content-Type": "application/json; charset=utf-8"])!
        let testUser = TestUser(age: 1, name: "test")
        let data = try JSONEncoder().encode(testUser)
        let mockExecutor = MockRequestExecutor(mockedData: data,
                                               mockedResponse: urlResponse)
        let client = NetworkClient(executor: mockExecutor, configuration: configuration)
        
        let response: NetworkResponse<TestUser> = try await client.send(endpoint)
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(response.value, testUser)
        XCTAssertEqual(response.contentType, "application/json")
    }
    
    // MARK: - Decoding Errors
    
    func test_send_invalidDecodableResponse_throwsDecodingFailedError() async throws {
        let urlResponse = HTTPURLResponse(url: URL(string: "https://www.example.com")!,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: ["Content-Type": "application/json"])!
        let testUser = TestUser(age: 1, name: "test")
        let data = try JSONEncoder().encode(testUser)
        let mockExecutor = MockRequestExecutor(mockedData: data,
                                               mockedResponse: urlResponse)
        let client = NetworkClient(executor: mockExecutor, configuration: configuration)
        struct SomeDecodable: Decodable {
            let id: String
        }
        
        do {
            let response: NetworkResponse<SomeDecodable> = try await client.send(endpoint)
            XCTFail("Expected decodingFailed error, but got \(response)")
        } catch {
            switch error {
            case NetworkError.decodingFailed:
                break
            default:
                XCTFail("Expected decodingFailed error, but got \(error)")
            }
        }
    }
    
    // MARK: - Content-Type errors
    
    func test_send_unexpectedContentType_throwsUnexpectedContentTypeError() async  {
        let urlResponse = HTTPURLResponse(url: URL(string: "https://www.example.com")!,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: ["Content-Type": "text/html"])!
        let mockExecutor = MockRequestExecutor(mockedResponse: urlResponse)
        let client = NetworkClient(executor: mockExecutor, configuration: configuration)
        
        do {
            let response: NetworkResponse<TestUser> = try await client.send(endpoint)
            XCTFail("Expected unexpectedContentType error, but got \(response)")
        } catch {
            switch error {
            case NetworkError.unexpectedContentType(let expected, let received):
                XCTAssertEqual(expected, "application/json")
                XCTAssertEqual(received, "text/html")
            default:
                XCTFail("Expected unexpectedContentType error, but got \(error)")
            }
        }
    }
    
    // MARK: - HTTP Errors
    
    func test_send_decodableResponseWith500Status_throwsHttpErrorBeforeDecoding() async {
        let urlResponse = HTTPURLResponse(url: URL(string: "https://www.example.com")!,
                                          statusCode: 500,
                                          httpVersion: nil,
                                          headerFields: ["Content-Type": "application/json"])!
        let mockExecutor = MockRequestExecutor(mockedResponse: urlResponse)
        let client = NetworkClient(executor: mockExecutor, configuration: configuration)
        
        do {
            let response: NetworkResponse<TestUser> = try await client.send(endpoint)
            XCTFail("Expected error but got \(response)")
        } catch {
            switch error {
            case NetworkError.httpError(let statusCode, let category):
                XCTAssertEqual(statusCode, 500)
                XCTAssertEqual(category, .serverError)
            default:
                XCTFail("Expected HttpError but got \(error)")
            }
        }
    }
    
    // MARK: - Transport Errors
    
    func test_send_decodableResponseWithTimeoutError_throwsTimeoutError() async {
        let urlResponse = HTTPURLResponse(url: URL(string: "https://www.example.com")!,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: ["Content-Type": "application/json"])!
        let mockedError = URLError(.timedOut)
        let mockExecutor = MockRequestExecutor(mockedResponse: urlResponse,
                                               mockedError: mockedError)
        let client = NetworkClient(executor: mockExecutor, configuration: configuration)
        
        do {
            let response: NetworkResponse<TestUser> = try await client.send(endpoint)
            XCTFail("Expected NetworkError.transport.timedOut but got \(response)")
        } catch {
            switch error {
            case NetworkError.transport(let error):
                XCTAssertEqual(error.code, .timedOut)
                
            default :
                XCTFail("Expected NetworkError.transport.timedOut but got \(error)")
            }
        }
    }
    
    // MARK: - NoContent Error
        func test_send_statusCode204_throwsNoContentError() async {
            let urlResponse = HTTPURLResponse(url: URL(string: "https://www.example.com")!,
                                              statusCode: 204,
                                              httpVersion: nil,
                                              headerFields: ["Content-Type": "application/json"])!
            let mockExecutor = MockRequestExecutor(mockedResponse: urlResponse)
            let client = NetworkClient(executor: mockExecutor, configuration: configuration)
        
        do {
            let response: NetworkResponse<TestUser> = try await client.send(endpoint)
            XCTFail("Expected NetworkError.noContent but got \(response)")
        } catch {
            switch error {
                case NetworkError.noContent:
                break
                
            default :
                XCTFail("Expected NetworkError.noContent but got \(error)")
            }
        }
    }
}
