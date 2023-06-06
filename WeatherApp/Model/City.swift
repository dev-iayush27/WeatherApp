//
//  City.swift
//  WeatherApp
//
//  Created by Ayush Gupta on 06/06/23.
//

import Foundation

struct City: Equatable, Identifiable {
    var id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    static func cities() -> [City] {
        return [
            City(id: 1259229, name: "Pune"),
            City(id: 1275339, name: "Mumbai"),
            City(id: 1273294, name: "Delhi"),
            City(id: 1277333, name: "Bengaluru"),
            City(id: 1275841, name: "Bhopal"),
            City(id: 1262321, name: "Mysore"),
            City(id: 1269743, name: "Indore"),
            City(id: 1275004, name: "Kolkata"),
            City(id: 7279746, name: "Noida"),
            City(id: 1269515, name: "Jaipur")
        ]
    }
}
