//
//  RequestBody.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 03/08/26.
//

/// Represents the body of an HTTP request.

import Foundation

public enum RequestBody {
    case none
    case json(any Encodable)
    case data(raw: Data, mimeType: MIMEType)
}
