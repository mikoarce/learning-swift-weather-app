//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Angela Yu on 24/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol TemperatureConversionProtocol {
    var tempMinAsCelcius: Float? { get }
    var tempMinAsFahrenheit: Float? { get }
    var tempMaxAsCelcius: Float? { get }
    var tempMaxAsFahrenheit: Float? { get }
    var currTempAsCelcius: Float? { get }
    var currTempAsFahrenheit: Float? { get }
}

struct TemperatureInfo {
    let humidity: Int?
    let pressure: Int?
    let tempMin: Float?
    let tempMax: Float?
    let currTemp: Float?
    
    private func convertTemperatureToCelcius(fromKelvin temp: Float) -> Float {
        return temp - 273.15
    }
    
    private func convertTemperatureToFahrenheit(fromKelvin temp: Float) -> Float {
        return (9.0/5.0) * convertTemperatureToCelcius(fromKelvin:temp) + 32.0
    }
}

extension TemperatureInfo : TemperatureConversionProtocol {
    //check out guard
    var tempMinAsCelcius: Float? {
        if let temp = tempMin {
            return convertTemperatureToCelcius(fromKelvin: temp)
        } else { return nil }
    }
    
    var tempMinAsFahrenheit: Float? {
        if let temp = tempMin {
            return convertTemperatureToFahrenheit(fromKelvin: temp)
        } else { return nil }
    }
    
    var tempMaxAsCelcius: Float? {
        if let temp = tempMax {
            return convertTemperatureToCelcius(fromKelvin: temp)
        } else { return nil }
    }
    
    var tempMaxAsFahrenheit: Float? {
        if let temp = tempMax {
            return convertTemperatureToFahrenheit(fromKelvin: temp)
        } else { return nil }
    }
    
    var currTempAsCelcius: Float? {
        if let temp = currTemp {
            return convertTemperatureToCelcius(fromKelvin: temp)
        } else { return nil }
    }
    
    var currTempAsFahrenheit: Float? {
        if let temp = currTemp {
            return convertTemperatureToFahrenheit(fromKelvin: temp)
        } else { return nil }
    }
}

class WeatherDataModel {
    var tempInfo: TemperatureInfo? = nil
    var weatherDesc: String? = nil
    var weatherSummary: String? = nil
    var country: String? = nil
    var cityName: String? = nil
    var sunriseTime: Date? = nil
    var sunsetTime: Date? = nil
    var windSpeed: Float? = nil
    
    var completeLocation: String {
        get { return "\(cityName ?? "nil"), \(country ?? "nil")" }
    }
    
    init(jsonDict: NSDictionary) {
        if let temperatureInfoDict = jsonDict.object(forKey: JSONKeys.KEY_TEMP_INFO) as? Dictionary<String, Any> {
            let humidity = temperatureInfoDict[JSONKeys.KEY_HUMIDITY] as? Int
            let tempMin = temperatureInfoDict[JSONKeys.KEY_MIN_TEMP] as? Float
            let tempMax = temperatureInfoDict[JSONKeys.KEY_MAX_TEMP] as? Float
            let temp = temperatureInfoDict[JSONKeys.KEY_CURR_TEMP] as? Float
            let pressure = temperatureInfoDict[JSONKeys.KEY_PRESSURE] as? Int
            tempInfo = TemperatureInfo(humidity: humidity, pressure: pressure, tempMin: tempMin, tempMax: tempMax, currTemp: temp)
        }
        
        if let locationInfoDict = jsonDict.object(forKey: JSONKeys.KEY_LOCATION_INFO) as? Dictionary<String, Any> {
            sunriseTime = Date(timeIntervalSince1970: locationInfoDict[JSONKeys.KEY_SUNRISE] as! Double)
            sunsetTime = Date(timeIntervalSince1970: locationInfoDict[JSONKeys.KEY_SUNSET] as! Double)
            country = locationInfoDict[JSONKeys.KEY_COUNTRY] as? String
        }
        
        if let weatherInfoDict = jsonDict.object(forKey: JSONKeys.KEY_WEATHER_INFO) as? [Dictionary<String, Any>] {
            weatherDesc = weatherInfoDict[0][JSONKeys.KEY_WEATHER_DESCRIPTION] as? String
            weatherSummary = weatherInfoDict[0][JSONKeys.KEY_WEATHER_SUMMARY] as? String
        }
        
        if let windInfoDict = jsonDict.object(forKey: JSONKeys.KEY_WIND_INFO) as? Dictionary<String, Any> {
            windSpeed = windInfoDict[JSONKeys.KEY_WIND_SPEED] as? Float
        }
        cityName = jsonDict.object(forKey: JSONKeys.KEY_CITY_NAME) as? String
    }
}
