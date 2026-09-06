//
//  NetworkClient.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 16/08/26.
//

import Foundation

/// A client for sending requests

public struct NetworkClient {
    private let executor: any RequestExecutor
    private let configuration: NetworkConfiguration
    
    public init (configuration: NetworkConfiguration) {
        self.executor = URLSessionRequestExecutor()
        self.configuration = configuration
    }
    
    public init(executor: any RequestExecutor,
                configuration: NetworkConfiguration) {
        self.executor = executor
        self.configuration = configuration
    }
    
    public func send<T: Decodable>(_ endPoint: any Endpoint) async throws -> NetworkResponse<T> {
        let request = try RequestBuilder.build(endPoint, baseURL: configuration.baseURL)
        let urlResponse: URLResponse
        let data: Data
        do {
            (data, urlResponse) = try await executor.execute(request)
        } catch let error as URLError {
            throw NetworkError.transport(error: error)
        }
        let statusCode = try validate(urlResponse)
        guard urlResponse.mimeType == endPoint.expectedContentType.rawValue else {
            throw NetworkError.unexpectedContentType(expected: endPoint.expectedContentType.rawValue, received: urlResponse.mimeType ?? "unknown")
        }
        do {
            let response = try JSONDecoder().decode(T.self, from: data)
            return NetworkResponse(value: response, statusCode: statusCode)
        } catch let error as DecodingError {
            throw NetworkError.decodingFailed(error: error)
        }
    }
    
    public func send(_ endPoint: any Endpoint) async throws -> EmptyResponse {
        let request = try RequestBuilder.build(endPoint, baseURL: configuration.baseURL)
        let urlResponse: URLResponse
        do {
            (_, urlResponse) = try await executor.execute(request)
            
        } catch let error as URLError {
            throw NetworkError.transport(error: error)
        }
        let statusCode = try validate(urlResponse)
        return EmptyResponse(statusCode: statusCode)
    }
    
    
    private func validate(_ response: URLResponse) throws -> Int {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        switch httpResponse.statusCode {
        case 200..<300:
            return httpResponse.statusCode
        case 401:
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, category: .unauthorized)
        case 403:
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, category: .forbidden)
        case 404:
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, category: .notFound)
        case 429:
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, category: .tooManyRequests)
        case 500..<600:
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, category: .serverError)
        default:
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, category: .unknown)
            
        }
    }
}
