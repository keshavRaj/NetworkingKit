//
//  NetworkError.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 03/08/26.
//

import Foundation

/// /// Represents errors that can occur while executing a network request.
public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case transport(error: URLError)
    case serializationFailed(error: Error)
    case unexpectedContentType(expected: String, received: String)
    case httpError(statusCode: Int, category: HTTPStatusCategory)
    case decodingFailed(error: DecodingError)
}

