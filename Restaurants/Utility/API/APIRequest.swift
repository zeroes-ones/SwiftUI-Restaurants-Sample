//
//  APIRequest.swift
//  Restaurants
//
//  Created by S on 10/27/20.
//

import Foundation
public enum HttpMethod: String {
    case get, post, put, delete
    var value: String {
        self.rawValue
    }
}

protocol APIRequest {
    var method: HttpMethod { get }
    var path: String { get }
    var parameters: [String : String] { get }
}

extension APIRequest {
    var path: String { "" }
}
extension APIRequest {
    func request(with baseURL: URL) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path),
                                             resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }

        components.queryItems = parameters.map {
            URLQueryItem(name: String($0), value: String($1))
        }

        guard let url = components.url else {
            fatalError("Could not get url")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

