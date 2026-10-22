//
//  NetworkResponse.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 16/08/26.
//

/// Represents the return value of ``NetworkClient`` for an HTTP Response with  status code and decoded data.

public struct NetworkResponse<T> {
    public let value: T
    public let statusCode: Int
    public let contentType: String?
}
