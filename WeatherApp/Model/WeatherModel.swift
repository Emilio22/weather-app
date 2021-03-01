//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Emilio Rodriguez on 2/24/21.
//

import Foundation

struct WeatherModel {
    let cityName: String
    var temp: Double
    var minTemp: Double
    var maxTemp: Double
    let description: String
    
    //Computed properties to create formatted strings from temp values
    var tempString: String {
        (String(format: "%.0f", temp))
    }
    
    var minTempString: String {
        (String(format: "%.0f", minTemp))
    }
    
    var maxTempString: String {
        (String(format: "%.0f", maxTemp))
    }
    
//    var celsius: Double {
//        (temp - 32) *  (5/9)
//    }
//
//    var celciusTempString: String {
//        (String(format: "%.0f", celsius))
//    }
    
    private func convertTempToCelsius(_ value: Double) -> Double{
        return (value - 32) *  (5/9)
    }
    private func convertTempToFahrenheit(_ value: Double) -> Double{
        return (value * (9/5)) + 32
    }
    
    private mutating func convertWeatherToCelcius() {
        self.temp = convertTempToCelsius(temp)
        self.maxTemp = convertTempToCelsius(maxTemp)
        self.minTemp = convertTempToCelsius(minTemp)
    }
    private mutating func convertWeatherToFahrenheight(){
        self.temp = convertTempToFahrenheit(temp)
        self.maxTemp = convertTempToFahrenheit(maxTemp)
        self.minTemp = convertTempToFahrenheit(minTemp)
    }
    
    var isCelcius = false {
        willSet {
            if isCelcius == true {
                convertWeatherToFahrenheight()
            } else {
                convertWeatherToCelcius()
            }
        }
    }
    
}
