//
//  TestUser.swift
//  NetworkingKit
//
//  Created by Keshav Raj on 05/08/26.
//

import Foundation

struct TestUser: Codable, Equatable {
    let age: Int
    let name: String
    
    init(age: Int, name: String) {
        self.age = age
        self.name = name
    }
}
