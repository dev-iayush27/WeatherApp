//
//  WeatherDetailsRow.swift
//  WeatherApp
//
//  Created by Ayush Gupta on 07/06/23.
//

import SwiftUI

struct WeatherDetailsRow: View {
    @State var weatherForecast: WeatherForecast
    
    var body: some View {
        VStack {
            Text(weatherForecast.city.name ?? "")
                .font(.system(size: 18))
                .fontWeight(.bold)
            Text("\(String(Int(weatherForecast.list.first?.main.temp ?? 0.0)))°C")
                .font(.system(size: 40))
                .fontWeight(.medium)
            Text(weatherForecast.list.first?.weather.first?.description.uppercased() ?? "")
            
            HStack {
                Text("H \(String(Int(weatherForecast.list.first?.main.tempMax ?? 0.0)))°C")
                    .padding(.trailing, 10)
                Text("L \(String(Int(weatherForecast.list.first?.main.tempMin ?? 0.0)))°C")
            }
            
            VStack(alignment: .leading) {
                Text("5-Days Forecast")
                    .padding(.vertical, 10)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                                
                ForEach(weatherForecast.uniqueList, id: \.dt) { weather in
                    HStack {
                        Text(weather.dt.getDateStringFromUTC())
                            .padding(.trailing, 5)
                        
                        AsyncImage(url: URL(string: "https://openweathermap.org/img/w/\(weather.weather.first?.icon ?? "").png")!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Image(systemName: "photo.fill")
                        }.frame(width: 35, height: 35)
                        
                        Spacer()
                        
                        Text("H \(String(Int(weather.main.tempMax)))°C")
                            .padding(.trailing, 10)
                        Text("L \(String(Int(weather.main.tempMin)))°C")
                    }
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
        }.padding(.top, 5)
    }
}
