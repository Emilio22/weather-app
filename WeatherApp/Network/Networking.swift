//
//  Networking.swift
//  WeatherApp
//
//  Created by Emilio Rodriguez on 2/24/21.
//

import Foundation

class Networking {
    
    static let sharedInstance = Networking()
    
    //base url with API key
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=695f0cfd188cf1fd5fd0f4abf7eef184&units=Imperial"
    
    
    
    func fetchWeatherBy(cityName: String, completion: @escaping (WeatherModel) -> Void ){
        
        //make URL
        if let url = URL(string: baseURL + "&q=\(cityName)") {
            //create URL Session
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                //check if there is an error, if so return
                if let error = error {
                    print("Error with fetching films: \(error)")
                    return
                }
                
                //if there is data, parse the JSON
                if let data = data {
                    do{
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
                        //send back weather
                        completion(weather)
                        
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
                    
            })
            task.resume()
        }
        
        
    }
    
}
