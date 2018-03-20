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
        
    }
}
