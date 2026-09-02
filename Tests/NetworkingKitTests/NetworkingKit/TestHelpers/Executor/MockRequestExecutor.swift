//
//  MockRequestExecutor.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 16/08/26.
//

@testable import NetworkingKit
import Foundation

struct MockRequestExecutor: RequestExecutor {
    private let mockedData: Data?
    private let mockedResponse: URLResponse
    private let mockedError: Error?
    
    init(mockedData: Data? = nil,
         mockedResponse: URLResponse
        ,mockedError: Error? = nil) {
        self.mockedData = mockedData
        self.mockedResponse = mockedResponse
        self.mockedError = mockedError
    }
    
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockedError {  throw error }
        return (mockedData ?? Data(), mockedResponse)
    }
}

