//
//  RestaurantsViewModel.swift
//  Restaurants
//
//  Created by S on 10/27/20.
//

import Foundation
import Combine

final class RestaurantsViewModel: ObservableObject, Identifiable {
    @Published var restaurants: [Restaurant.Result] = []

    private let apiClient: RestaurantsAPI
    private var cancellableSubscriber: AnyCancellable?
    private var disposables = Set<AnyCancellable>()
    var errorMessage: String?

    init(_ apiClient: RestaurantsAPI) {
        self.apiClient = apiClient
        startFetchData()
    }

    private func startFetchData() {
        let request = RestaurantsAPIRequest()
        fetchDataForRequest(request: request)
    }

    func fetchDataForRequest(request: APIRequest) {
        // Cancel any existing previous request
        if let subs = cancellableSubscriber {
            subs.cancel()
            cancellableSubscriber = nil
        }

        let publisher:AnyPublisher<[Restaurant.Result], APIError> = apiClient.send(apiRequest: request)
        let subscriber = publisher.receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] value in
                    guard let self = self else { return }
                    switch value {
                    case .failure(let error):
                        self.errorMessage = error.getErrorMessage()
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] results in
                    guard let self = self else { return }
                    self.restaurants = results
            })

        subscriber.store(in: &disposables) // Keep a reference to publisher until done
        cancellableSubscriber = AnyCancellable(subscriber)
    }
}
