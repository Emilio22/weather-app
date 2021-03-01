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
    
    @IBOutlet weak var tempUnitSwitch: UISegmentedControl!
    
    //Labels
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    @IBOutlet weak var tempUnitLabel: UILabel!
    
    var currentWeather : WeatherModel?
    
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
    func updateUI(){
        DispatchQueue.main.async {
            self.cityLabel.text = self.currentWeather?.cityName
            self.conditionLabel.text = self.currentWeather?.description
            self.currentTempLabel.text = self.currentWeather?.tempString
            self.highTempLabel.text = self.currentWeather?.maxTempString
            self.lowTempLabel.text = self.currentWeather?.minTempString
            self.tempUnitLabel.text = self.currentWeather?.unitSymbol
        }
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch tempUnitSwitch.selectedSegmentIndex {
        case 0:
            currentWeather?.isCelcius = false
        case 1:
            currentWeather?.isCelcius = true
        default:
            break
        }
        updateUI()
    }
    
}

// MARK:- Searchbar Delegate
extension WeatherViewController: UISearchBarDelegate {

    //When user enters search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchCityName = searchBar.text {
            // fetch weather by city name or zipcode
            // use weak self to prevent retain cycles
            Networking.sharedInstance.fetchWeatherWith(searchQuery: searchCityName) { [weak self] (result) in
                //Update UI
                
                switch result {
                case .success(let weather):
                    self?.currentWeather = weather
                    DispatchQueue.main.async {
                        self?.tempUnitSwitch.selectedSegmentIndex = 0
                    }
                    self?.updateUI()
                case .failure(let error):
                    print(error)
                
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
        
    
        //the locations is an array of locations, the last being the most recent
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            
            //latitude
            let lat = location.coordinate.latitude
            //longitude
            let lon = location.coordinate.longitude
        
            //fetch weather with latitude and longitude
            Networking.sharedInstance.fetchWeatherWithLocation(lat: lat, lon: lon) { [weak self] result in
                //If network call is successful, update UI with retrieve weather
                //else display error
                switch result {
                case .success(let weather):
                    self?.currentWeather = weather
                    DispatchQueue.main.async {
                        self?.tempUnitSwitch.selectedSegmentIndex = 0
                    }
                    self?.updateUI()
                case .failure(let error):
                    //TODO: Display error message
                    print(error)
                }
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Failed to find user's location \(error)")
    }
   
}
