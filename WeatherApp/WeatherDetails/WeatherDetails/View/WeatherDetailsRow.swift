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
            Text("Temp")
                .font(.system(size: 40))
                .fontWeight(.medium)
            Text("Status")
            
            HStack {
                Text("H Temp")
                Text("L Temp")
            }
            
            VStack(alignment: .leading) {
                Text("5-Days Forecast")
                    .padding(.vertical, 10)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                
                ForEach((0...5), id: \.self) { _ in
                    HStack {
                        Text("Day - Date")
                            .padding(.trailing, 5)
                        
                        AsyncImage(url: URL(string: "https://openweathermap.org/img/w/09d.png")!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Image(systemName: "photo.fill")
                        }.frame(width: 35, height: 35)
                        
                        Spacer()
                        
                        Text("H 25")
                            .padding(.trailing, 10)
                        Text("L 25")
                    }
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
        }.padding(.top, 5)
    }
}

//struct WeatherDetailsRow_Previews: PreviewProvider {
//    static var previews: some View {
//        WeatherDetailsRow(weatherForecast: WeatherForecast())
//    }
//}
