//
//  WeatherError.swift
//  WeatherApp
//
//  Created by Emilio Rodriguez on 2/28/21.
//

import Foundation

enum WeatherError: String, Error {
    case unableToComplete = "Unable to make server request"
    case invalidSearch = "Invalid search input, search city name or zip code"
    case invalidResponse = "Invalid response from the server"
    case invalidData = "Unable to retrieve data from server"
}
