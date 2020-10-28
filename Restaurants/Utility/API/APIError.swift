//
//  APIError.swift
//  Restaurants
//
//  Created by S on 10/27/20.
//

import Foundation

enum APIError: Error {
    case parsing(description: String)
    case network(description: String)

    func getErrorMessage() -> String {
        switch self {
        case .parsing:
            return "Data has wrong format"
        case .network:
            return "Unknown network error"
        }
    }
}
