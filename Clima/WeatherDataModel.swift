//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Angela Yu on 24/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import SwiftyJSON

struct TemperatureInfo {
    //Declare your model variables here
    let humidity: Int
    let tempMin: Int
    let tempMax: Int
    let pressure: Int
    
}

class WeatherDataModel {
    let tempInfo: TemperatureInfo? = nil
    let weatherType: String? = nil
    let country: String? = nil
    let cityName: String? = nil
    var completeLocation: String? {
        get { return "\(cityName ?? "nil"), \(country ?? "nil")" }
    }
    
    init(jsonDict: NSDictionary) {
        let temperatureInfoDict = jsonDict.object(forKey: JSONKeys.KEY_TEMP_INFO) as! Dictionary<String, Any>
        let locationInfoDict = jsonDict.object(forKey: JSONKeys.KEY_LOCATION_INFO) as! Dictionary<String, Any>
        let weatherInfoDict = jsonDict.object(forKey: JSONKeys.KEY_WEATHER_INFO) as! Dictionary<String, Any>
        let windInfoDict = jsonDict.object(forKey: JSONKeys.KEY_WIND_INFO) as! Dictionary<String, Any>
    
        let locationName = jsonDict.object(forKey: JSONKeys.KEY_LOCATION_NAME) as! String
        
    }
}
