import Foundation

// MARK: - Result
struct WeatherData: Codable {
    let weather: [Weather]
    let main: Main
    let name: String
}

// MARK: - Main
struct Main: Codable {
    let temp,minTemp, maxTemp: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
 
    }
}

// MARK: - Weather
struct Weather: Codable {
    let weatherDescription: String
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
    }
}
