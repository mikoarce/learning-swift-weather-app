//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = ApiKeys.OPEN_WEATHER_API_KEY //Insert OpenWeather API Key here!
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureRangeLabel: UILabel!
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var detailedWeatherInfoView: UIView!
    
    override func viewDidLoad() {
        
        //Setup location manager
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /*
     Method to get location of phone based on locationManager.desiredAccuracy set in viewDidLoad().
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if location.horizontalAccuracy > 0 { // Negative Horizontal Accuracy means invalid result.
                locationManager.stopUpdatingLocation() //Stop updating once location is found, else burn battery.
                findLocation(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
            }
        }
    }
    
    func findLocation(longitude: CLLocationDegrees, latitude: CLLocationDegrees) {
        let long = longitude
        let lat = latitude
        let urlAsString = "\(WEATHER_URL)?lat=\(lat)&lon=\(long)&appid=\(APP_ID)"
        let url = URL(string: urlAsString)
        
        Alamofire.request(url!, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonDict = value as! NSDictionary
                let weatherData = WeatherDataModel(jsonDict)
                self.populateWeatherDataUI(withData: weatherData)
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        handleError(error)
    }
    
    func handleError(_ error : Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }

    func populateWeatherDataUI(withData weatherData: WeatherDataModel) {
        cityLabel.text = weatherData.completeLocation
        if let tempInfo = weatherData.tempInfo {
            temperatureLabel.text = "\(tempInfo.currTempAsCelsius!.format(f: ".0"))°C"
            temperatureRangeLabel.text = "\(tempInfo.tempMinAsCelsius!.format(f: ".0")) to \(tempInfo.tempMaxAsCelsius!.format(f: ".0"))°C"
            pressureLabel.text = "\(tempInfo.pressure!) psi"
            humidityabel.text = "\(tempInfo.humidity!)%"
        }
        sunriseTimeLabel.text = weatherData.sunriseTime
        sunsetTimeLabel.text = weatherData.sunsetTime
        windSpeedLabel.text = "\(weatherData.windSpeed!.format(f: ".0")) meter/sec"
    }
}

extension WeatherViewController : CityWeatherInfoDelegate {
    func getWeatherInfoOf(location: String) {
        print("Getting weather info for: \(location)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let changeCityVC = segue.destination as! ChangeCityViewController
            changeCityVC.delegate = self
        }
    }
}

