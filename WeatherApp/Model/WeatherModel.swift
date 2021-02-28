//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Emilio Rodriguez on 2/24/21.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let temp: Double
    let minTemp: Double
    let maxTemp: Double
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
    
    var celcius: Double {
        (temp - 32) *  (5/9)
    }
    
    var celciusTempString: String {
        (String(format: "%.0f", celcius))
    }
}
