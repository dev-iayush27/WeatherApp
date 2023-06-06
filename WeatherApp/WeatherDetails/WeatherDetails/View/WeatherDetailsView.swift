//
//  WeatherDetailsView.swift
//  WeatherApp
//
//  Created by Ayush Gupta on 06/06/23.
//

import SwiftUI

struct WeatherDetailsView: View {
    @EnvironmentObject var viewModel: WeatherDetailsViewModel
    
    var body: some View {
        List() {
            ForEach(viewModel.weatherForecast ?? [], id: \.city.id) { weatherForecast in
                WeatherDetailsRow(weatherForecast: weatherForecast)
            }
        }
        .onAppear {
            print(viewModel.weatherForecast?.count ?? 0)
        }
        .navigationTitle("Weather Details")
    }
}

struct WeatherDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailsView()
    }
}
