//
//  Restaurants.swift
//  Restaurants
//
//  Created by S on 10/27/20.
//

import Foundation

enum Restaurant { }

extension Restaurant {
    struct Result: Codable, Equatable, Identifiable {
        let category: String?
        let description: String?
        let id: Int
        let name: String?
    }
}
extension Restaurant {
    struct API {
        static let urlPath = "http://www.json-generator.com/api/json/get/bQwCjWxBDS"
    }
}
