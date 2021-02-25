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
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }


    //Refresh Location Pressed
    @IBAction func refreshPressed(_ sender: UIButton) {
        
        locationManager.requestLocation()
    
    }
}

// MARK:- Searchbar Delegate
extension WeatherViewController: UISearchBarDelegate {

    //When user enters search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchCityName = searchBar.text {
            Networking.sharedInstance.fetchWeatherWith(searchQuery: searchCityName) { [weak self] (weather) in
                //Update UI
                //Must be on main queue to update UI
                DispatchQueue.main.async {
                    self?.cityLabel.text = weather.cityName
                    self?.conditionLabel.text = weather.description
                    self?.currentTempLabel.text = "\(weather.temp)"
                    self?.highTempLabel.text = "\(weather.maxTemp)"
                    self?.lowTempLabel.text = "\(weather.minTemp)"
                }
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
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
        
            Networking.sharedInstance.fetchWeatherWithLocation(lat: lat, lot: lon) { [weak self] (weather) in
                
                DispatchQueue.main.async {
                    self?.cityLabel.text = weather.cityName
                    self?.conditionLabel.text = weather.description
                    self?.currentTempLabel.text = "\(weather.temp)"
                    self?.highTempLabel.text = "\(weather.maxTemp)"
                    self?.lowTempLabel.text = "\(weather.minTemp)"
                }
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Failed to find user's location \(error)")
    }
   
}
