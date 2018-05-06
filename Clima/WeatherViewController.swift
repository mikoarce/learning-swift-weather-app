//
//  ViewController.swift
//  WeatherApp
//


import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
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

    let locationManager = CLLocationManager()
    let openWeatherMapService = OpenWeatherMapService()
    
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
        openWeatherMapService.getWeatherInfoWith(latitude: latitude, longitude: longitude) { (jsonDict) in
            if let jsonDict = jsonDict {
                let weatherData = WeatherDataModel(jsonDict)
                self.populateWeatherDataUI(withData: weatherData)
            } else {
                self.handleError()
            }
        }
    }

    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        handleError()
    }

    func handleError() {
        resetUI()
        cityLabel.text = "Location Unavailable"
    }

    func populateWeatherDataUI(withData weatherData: WeatherDataModel) {
        resetUI()
        cityLabel.text = weatherData.completeLocation
        if let tempInfo = weatherData.tempInfo {
            temperatureLabel.text = "\(tempInfo.currTempAsCelsius!.format(val: ".0"))°C"
            temperatureRangeLabel.text = """
                \(tempInfo.tempMinAsCelsius!.format(val: ".0")) to
                \(tempInfo.tempMaxAsCelsius!.format(val: ".0"))°C
            """

            if let pressure = tempInfo.pressure { pressureLabel.text = "\(pressure) psi" }
            if let humidity = tempInfo.humidity { humidityabel.text = "\(humidity)%" }
        }

        sunriseTimeLabel.text = weatherData.sunriseTime
        sunsetTimeLabel.text = weatherData.sunsetTime
        windSpeedLabel.text = "\(weatherData.windSpeed!.format(val: ".0")) meter/sec"

        weatherIcon.image = weatherData.weatherIdImage
    }

    private func resetUI() {
        cityLabel.text = ""
        temperatureLabel.text = ""
        temperatureRangeLabel.text = ""
        pressureLabel.text = ""
        humidityabel.text = ""
        sunriseTimeLabel.text = ""
        sunsetTimeLabel.text = ""
        windSpeedLabel.text = ""
        weatherIcon.image = nil
    }
}

extension WeatherViewController: CityWeatherInfoDelegate {
    func getWeatherInfoOf(location: String) {
        openWeatherMapService.getWeatherInfoWith(locationName: location) { (jsonDict) in
            if let jsonDict = jsonDict {
                let weatherDataModel = WeatherDataModel(jsonDict)
                self.populateWeatherDataUI(withData: weatherDataModel)
            } else {
                self.handleError()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let changeCityVC = segue.destination as? ChangeCityViewController
            changeCityVC?.delegate = self
        }
    }
}
