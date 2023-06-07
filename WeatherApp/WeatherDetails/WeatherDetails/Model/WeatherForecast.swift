//
//  WeatherForecast.swift
//  WeatherApp
//
//  Created by Ayush Gupta on 06/06/23.
//

import Foundation

// MARK: - Weather
struct WeatherForecast: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [ForecastList]
    let city: CityData
}

// MARK: - CityData
struct CityData: Codable {
    let id: Int?
    let name: String?
    let coord: Coord
    let country: String?
    let population, timezone, sunrise, sunset: Int
}

// MARK: - ForecastList
struct ForecastList: Codable {
    let dt: Double
    let main: MainClass
    let weather: [WeatherElement]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let rain: Rain?
    let sys: Sys
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double
    
    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: String
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

extension WeatherForecast {
    var uniqueList: [ForecastList] {
        var uniqueList = [ForecastList]()
        for each in list {
            if !uniqueList.contains(where: {
                $0.dt.getDateStringFromUTC() == each.dt.getDateStringFromUTC()
            }) {
                uniqueList.append(each)
            }
        }
        return uniqueList
    }
}
