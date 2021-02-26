//
//  Networking.swift
//  WeatherApp
//
//  Created by Emilio Rodriguez on 2/24/21.
//

import Foundation
import CoreLocation

class Networking {
    
    //Create a singleton of this class
    static let sharedInstance = Networking()
    
    //base url with API key
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=695f0cfd188cf1fd5fd0f4abf7eef184&units=Imperial"
    
    
    // Fetch Weather with a search Query.  Function then differentiates if the query is a city name or zipcode and then builds a URL to make API call
    func fetchWeatherWith(searchQuery: String, completion: @escaping (WeatherModel) -> Void ){
        var urlString = ""
        //check if searchQuery is a zipcode or string
        if Int(searchQuery) != nil {
            urlString = baseURL + "&zip=\(searchQuery)"
        } else {
            //replace any space charecters with "+"
            urlString = baseURL + "&q=\(searchQuery.replacingOccurrences(of: " ", with: "+"))"
        }
        
        //make URL
        if let url = URL(string: urlString) {
            //create URL Session
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                //check if there is an error, if so return
                if let error = error {
                    print("Error with fetching weather: \(error)")
                    return
                }
                
                //if there is data, parse the JSON
                if let weather = self.parseJSONtoWeather(data: data){
                    completion(weather)
                }
    
            })
            task.resume()
        }
    }
    
    // Fetch weather with latitude and longitude
    func fetchWeatherWithLocation(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (WeatherModel) -> Void) {
        let urlString = "\(baseURL)&lat=\(lat)&lon=\(lon)"

        if let url = URL(string: urlString) {
            //create URL Session
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                //check if there is an error, if so return
                if let error = error {
                    print("Error with fetching weather: \(error)")
                    return
                }
                //if there is data, parse the JSON
                if let weather = self.parseJSONtoWeather(data: data){
                    completion(weather)
                }
                
            })
            task.resume()
        }
    }
    
    func parseJSONtoWeather(data: Data?) -> WeatherModel? {
        //Check if there is data
        if let data = data {
            do{
                //parse JSON into an instance of WeatherModel
                let decoder = JSONDecoder()
                let result = try decoder.decode(Result.self, from: data)
                let cityName = result.name
                let temp = result.main.temp
                let minTemp = result.main.minTemp
                let maxTemp = result.main.maxTemp
                let description = result.weather[0].weatherDescription
                
                let weather = WeatherModel(cityName: cityName,
                                           temp: temp,
                                           minTemp: minTemp,
                                           maxTemp: maxTemp,
                                           description: description)
                return(weather)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        //return nil if no data
        return(nil)
    }
}
