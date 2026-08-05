//
//  RequestExecutor.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 05/08/26.
//

import Foundation

/// An abstraction responsible for executing URL requests.

public protocol RequestExecutor {
    /// Executes the specified URLRequest.
    ///
    /// - Parameter request: The request to execute.
    /// - Returns: The response data and URL response.
    /// - Throws: An error if the request fails.
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse)
}
