//
//  WebService.swift
//  WeatherApp
//
//  Created by Ayush Gupta on 06/06/23.
//

import Foundation

final class WebService {
    private var urlSession: URLSession
    private var cityID: String
    
    init(cityID: String, urlSession: URLSession = .shared) {
        self.cityID = cityID
        self.urlSession = urlSession
    }
    
    func getWeatherForecastData(completion: @escaping (Result<WeatherForecast?, ErrorType>) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/forecast?id=\(cityID)&appid=\(Constants.apiKey)"
        guard let url = URL(string: url) else {
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
