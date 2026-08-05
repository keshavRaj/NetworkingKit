//
//  URLSessionRequestExecutor.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 05/08/26.
//

import Foundation

/// Default implementation of ``RequestExecutor`` backed by `URLSession`.
struct URLSessionRequestExecutor: RequestExecutor {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try await session.data(for: request)
    }
}
