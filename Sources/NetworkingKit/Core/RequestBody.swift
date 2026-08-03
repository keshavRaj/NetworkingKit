//
//  RequestBody.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 03/08/26.
//

/// Represents the body of an HTTP request.

public enum RequestBody {
    case none
    case json(any Encodable)
}
