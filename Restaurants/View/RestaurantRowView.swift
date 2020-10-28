//
//  RestaurantRowView.swift
//  Restaurants
//
//  Created by S on 10/27/20.
//

import Foundation
import SwiftUI

struct RestaurantRowView: View {
    private let data: Restaurant.Result

    init(data: Restaurant.Result) {
      self.data = data
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 100.0) {
                Text("\(data.name ?? "")")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            Text("\(data.category ?? "")")
                .font(.system(size: 12))
                .foregroundColor(.primary)
            Text("\(data.description ?? "")")
                .font(.system(size: 12))
                .foregroundColor(.primary)
        }
    }
}
