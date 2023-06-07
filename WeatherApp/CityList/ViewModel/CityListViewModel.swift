//
//  CityListViewModel.swift
//  WeatherApp
//
//  Created by Ayush Gupta on 06/06/23.
//

import Foundation

final class CityListViewModel {
    var weatherDetailsForCities: [WeatherForecast]? = []
    
    var cities: [City] {
        return City.cities().sorted{$0.name < $1.name}
    }
    
    var citiesCount: Int {
        return cities.count
    }
    
    var title: String {
        return "Select Multiple Cities"
    }
    
    func callWeatherForecatAPI(
        selectedCities: [City],
        completion: @escaping(_ weatherList: [WeatherForecast], _ errorMessage: String) -> Void
    ) {
        self.weatherDetailsForCities?.removeAll()
        let group = DispatchGroup()
        for city in selectedCities {
            group.enter()
            WebService(cityID: String(city.id)).getWeatherForecastData() { result in
                switch result {
                case .success(let response):
                    if let weatherInfo = response {
                        self.weatherDetailsForCities?.append(weatherInfo)
                        group.leave()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                        completion([], error.localizedDescription)
                        group.leave()
                        return
                    }
                }
            }
        }
        group.wait()
        completion(weatherDetailsForCities ?? [], "")
    }
}
