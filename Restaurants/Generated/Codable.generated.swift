//
//  Codable.generated.swift
//  Restaurants
//
//  Created by S on 10/27/20.
//

import Foundation
extension Restaurant.Result {
    private enum CodingKeys: String, CodingKey {
        case category
        case description
        case id
        case name
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? Int.random(in: 0..<Int.max)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
    }
}
