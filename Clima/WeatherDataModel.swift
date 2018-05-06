//
//  WeatherDataModel.swift
//  WeatherApp
//


import UIKit
import SwiftyJSON

class WeatherDataModel {
    var tempInfo: TemperatureInfo? = nil
    var weatherDesc: String? = nil
    var weatherSummary: String? = nil
    var weatherId: Int? = nil
    var country: String? = nil
    var cityName: String? = nil
    var sunriseDateTime: Date? = nil
    var sunsetDateTime: Date? = nil
    var windSpeed: Double? = nil
    
    var completeLocation: String {
        get { return "\(cityName ?? "nil"), \(country ?? "nil")" }
    }
    
    var weatherIdImage: UIImage {
        get {
            guard let weatherId = self.weatherId,
                      let image = UIImage(named: self.getWeatherIconName(condition: weatherId)) else {
                        return UIImage(named: "dunno")!
            }
            return image
        }
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
    
    /*
     Since SwiftyJSON is not meant for serialization, we're doing this manually.
     TODO: Check out other APIs for serialization (including Apple's own JSON API).
     */
    init(_ jsonDict: NSDictionary) {
        if let temperatureInfoDict = jsonDict.object(forKey: JSONKeys.KEY_TEMP_INFO) as? Dictionary<String, Any> {
            let humidity = temperatureInfoDict[JSONKeys.KEY_HUMIDITY] as? Int
            let tempMin = temperatureInfoDict[JSONKeys.KEY_MIN_TEMP] as? Double
            let tempMax = temperatureInfoDict[JSONKeys.KEY_MAX_TEMP] as? Double
            let temp = temperatureInfoDict[JSONKeys.KEY_CURR_TEMP] as? Double
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
            weatherId = weatherInfoDict[0][JSONKeys.KEY_WEATHER_ID] as? Int
        }
        
        if let windInfoDict = jsonDict.object(forKey: JSONKeys.KEY_WIND_INFO) as? Dictionary<String, Any> {
            windSpeed = windInfoDict[JSONKeys.KEY_WIND_SPEED] as? Double
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
    
    private func getWeatherIconName(condition: Int) -> String {
        switch (condition) {
            case 0...300:
                return "tstorm1"
            case 301...500:
                return "light_rain"
            case 501...600:
                return "shower3"
            case 601...700:
                return "snow4"
            case 701...771:
                return "fog"
            case 772...799:
                return"tstorm3"
            case 800 :
                return"sunny"
            case 801...804:
                return "cloudy2"
            case 900...903, 905...1000:
                return "tstorm3"
            case 903:
                return "snow5"
            case 904:
                return "sunny"
            default:
                return "dunno"
            }
    }
    
    
}
