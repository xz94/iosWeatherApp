//
//  ViewController.swift
//  Weather
//
//  Created by Winnie Zhu on 11/23/19.
//  Copyright © 2019 Xuan Zhu. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import Alamofire


class InitialViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    let locationManager: CLLocationManager = CLLocationManager()
//    private let networkingClient = NetworkingClient()
    var weatherManager = WeatherManager()
    var lat = "45"
    var lng = "123"
    var temperature = ""
    var summary = ""
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
//      locationManager.stopUpdatingLocation();
        
        searchBar.backgroundImage = UIImage();
        searchBar.placeholder = "Enter city name...";
        currentView.layer.cornerRadius = 12;
        currentView.layer.borderWidth = 1;
        searchBar.delegate = self;
    }
    
    // get current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for currentLocation in locations {
            self.lat = String(currentLocation.coordinate.latitude);
            self.lng = String(currentLocation.coordinate.longitude);
            weatherManager.fetchWeather(lat: self.lat, lng: self.lng)
//            networkingClient.getLocWea(lat: self.lat, lng: self.lng) { (data, error) in
//                if let error = error {
//                    print(error.localizedDescription);
//                } else if let weatherData = data {
//                    print(weatherData.self)
//                }
//            }
        }
    }
    
    // 添加能够捕捉search field改变的function， 然后进行autocomplete
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)");
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(searchBar.text ?? "Default Value")");
        searchBar.endEditing(true);
        searchBar.text = "";
    }
}

