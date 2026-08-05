//
//  FailingEncodable.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 05/08/26.
//

struct FailingEncodable: Encodable {
    enum TestError: Error, Equatable {
        case intentionalFail
    }
    
    func encode(to encoder: any Encoder) throws {
        throw TestError.intentionalFail
    }
}

