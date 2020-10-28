//
//  RestaurantsAPIRequest.swift
//  Restaurants
//
//  Created by S on 10/27/20.
//

import Foundation
class RestaurantsAPIRequest: APIRequest {
    let method = HttpMethod.get
    var parameters = [String: String]()
}
