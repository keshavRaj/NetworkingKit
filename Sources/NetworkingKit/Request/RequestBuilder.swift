//
//  RequestBuilder.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 04/08/26.
//

import Foundation
/// Builds URLRequest to be sent to the URLSession.

public enum RequestBuilder {
    public static func build(_ endpoint: any Endpoint, baseURL: URL) throws  -> URLRequest {
        guard let url = buildURLComponents(endpoint, baseURL: baseURL).url else {
            throw NetworkError.invalidURL
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        
        /// Intentionally do not restrict request bodies based on HTTP method.
        /// Some servers accept request bodies for methods such as GET or DELETE.
        /// RequestBuilder builds the request described by the Endpoint without
        /// enforcing application-specific HTTP semantics.
        try applyBody(endpoint.body, to: &urlRequest)
        applyHeaders(endpoint.headers, to: &urlRequest)
      
        return urlRequest
    }
    
    private static func buildURLComponents(_ endpoint: any Endpoint, baseURL: URL) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = removeTrailingSlash(from: baseURL.path) + endpoint.path
        urlComponents.queryItems = endpoint.queryItems.isEmpty ? nil : endpoint.queryItems
        return urlComponents
    }
    
    private static func applyBody(_ body: RequestBody, to request: inout URLRequest) throws {
        do {
            switch body {
            case .none:
                break
                
            case .json(let body):
                request.httpBody = try JSONEncoder().encode(body)
            }
        } catch {
            throw NetworkError.serializationFailed(error: error)
        }
    }
    
    private static func applyHeaders(_ headers: [String: String], to request: inout URLRequest) {
        for (header, value) in headers {
            request.addValue(value, forHTTPHeaderField: header)
        }
    }
    
    private static func removeTrailingSlash(from path: String) -> String {
        guard path.hasSuffix("/") else {
            return path
        }
        return String(path.dropLast())
    }
}
