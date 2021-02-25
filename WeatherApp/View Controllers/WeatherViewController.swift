//
//  ViewController.swift
//  WeatherApp
//
//  Created by Emilio Rodriguez on 2/24/21.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }


    //Refresh Location Pressed
    @IBAction func refreshPressed(_ sender: UIButton) {
        
    }
}

// MARK:- Searchbar Delegate
extension WeatherViewController: UISearchBarDelegate {

    //When user enters search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchCityName = searchBar.text {
            Networking.sharedInstance.fetchWeatherBy(searchQuery: searchCityName) { [weak self] (weather) in
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
