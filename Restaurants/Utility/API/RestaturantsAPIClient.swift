//
//  RestaturantsAPIClient.swift
//  Restaurants
//
//  Created by S on 10/27/20.
//

import Foundation
import Combine

protocol RestaurantsAPI: Any {
    func send<T: Codable>(apiRequest: APIRequest) -> AnyPublisher<T, APIError>
}

final class RestaurantsAPIClient: RestaurantsAPI {
    private let baseURL = URL(string: Restaurant.API.urlPath)!
    private let session: URLSession = .shared

    func send<T: Codable>(apiRequest: APIRequest) -> AnyPublisher<T, APIError> {
        return session.dataTaskPublisher(for: apiRequest.request(with: baseURL))
        .tryMap { (data, response) -> Data in
            let response = response as! HTTPURLResponse

            if response.statusCode == 200 {
                return data
            }
            let localizedStatusCodeDescription =
                HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
            throw NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: localizedStatusCodeDescription])

        }
        .mapError {
            APIError.network(description: $0.localizedDescription)
        }
        .flatMap(maxPublishers: .max(1)) { data in
            decodeToObject(data)
        }
        .eraseToAnyPublisher()
    }
}
