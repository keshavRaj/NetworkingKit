//
//  HTTPErrorCategory.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 03/08/26.
//
 
/// Common HTTP Status Category

public enum HTTPStatusCategory {
    case unauthorized //401
    case forbidden //403
    case notFound //404
    case tooManyRequests //429
    case serverError //5xx
    case unknown
}
