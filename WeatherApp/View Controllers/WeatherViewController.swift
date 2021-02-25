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
        cityLabel.text = searchBar.text
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            searchBar.text = ""
            searchBar.resignFirstResponder()
    }
    
}