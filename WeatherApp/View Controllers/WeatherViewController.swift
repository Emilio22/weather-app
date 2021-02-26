//
//  ViewController.swift
//  WeatherApp
//
//  Created by Emilio Rodriguez on 2/24/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //Labels
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    
        locationManager.delegate = self
        
        //requestion location and authorization
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }


    //Refresh Location Pressed
    @IBAction func refreshPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    //update UI
    func updateUI(weather: WeatherModel){
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.conditionLabel.text = weather.description
            self.currentTempLabel.text = weather.tempString
            self.highTempLabel.text = weather.maxTempString
            self.lowTempLabel.text = weather.minTempString
        }
    }
    
}

// MARK:- Searchbar Delegate
extension WeatherViewController: UISearchBarDelegate {

    //When user enters search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchCityName = searchBar.text {
            // use weak self to prevent retain cycles
            Networking.sharedInstance.fetchWeatherWith(searchQuery: searchCityName) { [weak self] (weather) in
                //Update UI
                self?.updateUI(weather: weather)
            }
        }
        searchBar.text = ""
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            searchBar.text = ""
            searchBar.resignFirstResponder()
    }
    
}

//MARK:- Location Manager Delegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
    
        //the locations is an array of locations, the last being the most recent
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            
            //latitude
            let lat = location.coordinate.latitude
            //longitude
            let lon = location.coordinate.longitude
        
            //fetch weather with latitude and longitude
            Networking.sharedInstance.fetchWeatherWithLocation(lat: lat, lon: lon) { [weak self] (weather) in
                
                DispatchQueue.main.async {
                    self?.updateUI(weather: weather)
                }
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Failed to find user's location \(error)")
    }
   
}
