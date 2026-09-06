//
//  EmptyResponse.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 16/08/26.
//

/// Represents the return value of ``NetworkClient`` for an HTTP Response with only a status code.

public struct EmptyResponse {
    public let statusCode: Int
}
