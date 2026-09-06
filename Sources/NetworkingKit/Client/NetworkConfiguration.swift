//
//  NetworkConfiguration.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 16/08/26.
//

import Foundation

/// Defines configuration used by the ``NetworkClient``.

public struct NetworkConfiguration {
    public let baseURL: URL
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
}
