//
//  RestaurantClientTests.swift
//  RestaurantsTests
//
//  Created by S on 10/27/20.
//

import Foundation
import XCTest
import Combine
import Hippolyte

@testable import Restaurants

class APIClientTests: XCTestCase {

    var apiClient: RestaurantsAPI!
    var disposables = Set<AnyCancellable>()
    var request:RestaurantsAPIRequest!
    var url:URL!

    override func setUp() {
        apiClient = RestaurantsAPIClient()
        request = RestaurantsAPIRequest()
        url = request.request(with: URL(string: "http://www.json-generator.com/api/json/get/bQwCjWxBDS")!).url

    }

    override func tearDown() {
        Hippolyte.shared.stop()
        super.tearDown()
    }

    func testSendSuccess() {
        var stub = StubRequest(method: .GET, url: url)
        var response = StubResponse.Builder()
            .stubResponse(withStatusCode: 200)
            .build()

        let mockedBody = """
[
{
category: "fast food",
description: "This is the test description for restaurant 1",
name: "Restaurant 1",
id: 1
},
{
category: "ethnic",
description: "This is the test description for restaurant 2",
name: "Restaurant 2",
id: 2
},
{
category: "fast causal",
description: "This is the test description for restaurant 3",
name: "Restaurant 3",
id: 3
},
{
category: "fine dining",
description: "This is the test description for restaurant 4",
name: "Restaurant 4",
id: 4
},
{
category: "Bistro",
description: "This is the test description for restaurant 5",
name: "Restaurant 5",
id: 5
}
]
"""
            .data(using: .utf8)!

        response.body = mockedBody
        stub.response = response
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()

        let expectation = self.expectation(description: "Mock network call success")
        let publisher:AnyPublisher<[Restaurant.Result], APIError> = apiClient.send(apiRequest: request)
        publisher.sink(receiveCompletion: { [weak self] value in
            guard let _ = self else { return }
            switch value {
            case .failure:
                XCTFail("Sink failed")
            case .finished:
                break
            }
            }
            , receiveValue: { [weak self] result in
                guard let _ = self else {
                    return
                }
                XCTAssertEqual(result.count, 5)
                expectation.fulfill()
            })
            .store(in: &disposables)

        wait(for: [expectation], timeout: 1)
    }

    func testSendNetworkError() {
        var stub = StubRequest(method: .GET, url: url!)
        let response = StubResponse.Builder()
            .stubResponse(withStatusCode: 500)
            .build()
        stub.response = response
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()

        let expectation = self.expectation(description: "Mock network call error")
        let publisher:AnyPublisher<[Restaurant.Result], APIError> = apiClient.send(apiRequest: request)
        publisher.sink(receiveCompletion: { [weak self] value in
            guard let _ = self else { return }
            switch value {
            case .failure(let error):
                switch error {
                case .network:
                        expectation.fulfill()
                    default:
                        XCTFail()
                }
                break
            case .finished:
                XCTFail("Should not succeed")
                break
            }
            }
            , receiveValue: { [weak self] result in
                guard let _ = self else {
                    return
                }
                XCTFail("Should not get a result: \(result)")

        })
            .store(in: &disposables)

        wait(for: [expectation], timeout: 1)
    }

    func testSendParseError() {
        let mockedBadBody = """
        {
                "error": "something happened"
        }
        """.data(using: .utf8)!

        var stub = StubRequest(method: .GET, url: url!)
        var response = StubResponse.Builder()
            .stubResponse(withStatusCode: 200)
            .build()
        response.body = mockedBadBody
        stub.response = response
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()

        let expectation = self.expectation(description: "Mock parsing error")
        let publisher:AnyPublisher<[Restaurant.Result], APIError> = apiClient.send(apiRequest: request)
        publisher.sink(receiveCompletion: { [weak self] value in
            guard let _ = self else { return }
            switch value {
            case .failure(let error):
                switch error {
                case .parsing:
                    expectation.fulfill()
                default:
                    XCTFail()
                }
                break
            case .finished:
                XCTFail("Should not succeed")
                break
            }
            }
            , receiveValue: { [weak self] result in
                guard let _ = self else {
                    return
                }
                XCTFail("Should not get a result: \(result)")

        })
            .store(in: &disposables)

        wait(for: [expectation], timeout: 1)
    }
}
