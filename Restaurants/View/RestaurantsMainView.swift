//
//  RestaurantsMainView.swift
//  Restaurants
//
//  Created by S on 10/27/20.
//

import Foundation
import SwiftUI

struct RestaurantsMainView: View {
    @ObservedObject var viewModel: RestaurantsViewModel

    init(viewModel: RestaurantsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.restaurants.isEmpty {
                    ActivityIndicator(style: .large, color: .red, isAnimating: true)
                } else if viewModel.errorMessage != nil {
                    Text("\(viewModel.errorMessage ?? "")")
                        .font(.headline)
                        .foregroundColor(.primary)
                } else {
                    //Result list
                    Section {
                        List {
                            ForEach(viewModel.restaurants, id: \.id) { data in
                                RestaurantRowView(data: data)
                            }
                        }
                    }
                    .animation(.default)
                }
            }
            .navigationBarTitle(Text("Restaurants"), displayMode: .large)
        }
    }
}
