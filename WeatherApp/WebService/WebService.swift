//
//  WebService.swift
//  WeatherApp
//
//  Created by Ayush Gupta on 06/06/23.
//

import Foundation
import CoreLocation

final class WebService {
    private var urlSession: URLSession
    private var cityID: String
    private var coordinates: CLLocationCoordinate2D
    
    init(
        urlSession: URLSession = .shared,
        cityID: String = "",
        coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    ) {
        self.cityID = cityID
        self.urlSession = urlSession
        self.coordinates = coordinates
    }
    
    func getWeatherForecastData(completion: @escaping (Result<WeatherForecast?, ErrorType>) -> Void) {
        var serviceURL = ""
        if cityID.isEmpty {
            serviceURL = "https://api.openweathermap.org/data/2.5/forecast?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&units=metric&appid=\(Constants.apiKey)"
        } else {
            serviceURL = "https://api.openweathermap.org/data/2.5/forecast?id=\(cityID)&units=metric&appid=\(Constants.apiKey)"
        }
        guard let url = URL(string: serviceURL) else {
            completion(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let dataTask = self.urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.failedRequest(description: error.localizedDescription)))
                return
            }
            if let data = data {
                do {
                    print(String(data: data, encoding: .utf8) ?? "")
                    let weatherData = try JSONDecoder().decode(WeatherForecast.self, from: data)
                    completion(.success(weatherData))
                } catch {
                    completion(.failure(.responseParsingError))
                }
            }
        }
        dataTask.resume()
    }
}
