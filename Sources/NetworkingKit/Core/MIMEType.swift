//
//  MIMEType.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 03/08/26.
//

///  Represents the supported MIME types..

public enum MIMEType {
    case json
    case custom(String)

    public var rawValue: String {
        switch self {
        case .json:
            return "application/json"
        case .custom(let raw):
            return raw
        }
    }
}
