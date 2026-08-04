//
//  EndPoint.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 03/08/26.
//

import Foundation

/// Represents an HTTP Endpoint.

public protocol Endpoint {
    /// Relative path of the endpoint.
    ///
    /// - Important:
    ///   Must begin with "/".
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: RequestBody { get }
    var expectedContentType: MIMEType { get }
    var timeout: TimeInterval? { get }
    var cachePolicy: URLRequest.CachePolicy? { get }
}

public extension Endpoint {
    var queryItems: [URLQueryItem] { [] }
    var headers: [String: String] { [:] }
    var body: RequestBody { .none }
    var expectedContentType: MIMEType { .json }
    var timeout: TimeInterval? { nil }
    var cachePolicy: URLRequest.CachePolicy? { nil }
}
