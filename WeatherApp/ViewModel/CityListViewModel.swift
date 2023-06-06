//
//  CityListViewModel.swift
//  WeatherApp
//
//  Created by Ayush Gupta on 06/06/23.
//

import Foundation

final class CityListViewModel {
    
    var cities: [City] {
        return City.cities().sorted{$0.name < $1.name}
    }
}
