//
//  WeatherDetailsViewModel.swift
//  WeatherApp
//
//  Created by Ayush Gupta on 07/06/23.
//

import Foundation

final class WeatherDetailsViewModel: ObservableObject {
    
    var weatherForecast: [WeatherForecast]?
    
    init(weatherForecast: [WeatherForecast]? = []) {
        self.weatherForecast = weatherForecast
    }
}
