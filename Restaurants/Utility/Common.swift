//
//  Common.swift
//  Restaurants
//
//  Created by S on 10/27/20.
//

import Combine
import Foundation

func decodeToObject<T: Decodable>(_ data: Data) -> AnyPublisher<T, APIError> {
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .secondsSince1970

  return Just(data)
    .decode(type: T.self, decoder: decoder)
    .mapError { error in
        .parsing(description: error.localizedDescription)
    }
    .eraseToAnyPublisher()
}
