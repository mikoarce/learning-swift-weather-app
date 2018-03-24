//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Angela Yu on 24/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import SwiftyJSON

class WeatherDataModel {
    var tempInfo: TemperatureInfo? = nil
    var weatherDesc: String? = nil
    var weatherSummary: String? = nil
    var country: String? = nil
    var cityName: String? = nil
    var sunriseDateTime: Date? = nil
    var sunsetDateTime: Date? = nil
    var windSpeed: Float? = nil
    
    var completeLocation: String {
        get { return "\(cityName ?? "nil"), \(country ?? "nil")" }
    }
    
    var sunriseTime: String {
        get {
            guard let sunriseDateTime = sunriseDateTime else {
                return "Unavailable"
            }
            return self.formatTimeFrom(date: sunriseDateTime)
        }
    }
    
    var sunsetTime: String {
        get {
            guard let sunsetDateTime = sunsetDateTime else {
                return "Unavailable"
            }
            return self.formatTimeFrom(date: sunsetDateTime)
        }
    }
    
    //TODO: Refactor by removing hard coded stuff
    init(_ jsonDict: NSDictionary) {
        if let temperatureInfoDict = jsonDict.object(forKey: JSONKeys.KEY_TEMP_INFO) as? Dictionary<String, Any> {
            let humidity = temperatureInfoDict[JSONKeys.KEY_HUMIDITY] as? Int
            let tempMin = temperatureInfoDict[JSONKeys.KEY_MIN_TEMP] as? Float
            let tempMax = temperatureInfoDict[JSONKeys.KEY_MAX_TEMP] as? Float
            let temp = temperatureInfoDict[JSONKeys.KEY_CURR_TEMP] as? Float
            let pressure = temperatureInfoDict[JSONKeys.KEY_PRESSURE] as? Int
            tempInfo = TemperatureInfo(humidity: humidity, pressure: pressure, tempMin: tempMin, tempMax: tempMax, currTemp: temp)
        }
        
        if let locationInfoDict = jsonDict.object(forKey: JSONKeys.KEY_LOCATION_INFO) as? Dictionary<String, Any> {
            sunriseDateTime = Date(timeIntervalSince1970: locationInfoDict[JSONKeys.KEY_SUNRISE] as! Double)
            sunsetDateTime = Date(timeIntervalSince1970: locationInfoDict[JSONKeys.KEY_SUNSET] as! Double)
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
    
    private func formatTimeFrom(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = formatter.calendar.timeZone
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        return formatter.string(from: date)
    }
    
    private func interpretImage(fromValue: Int) {
        
    }
}
