//
//  JSONDictKeys.swift
//  Clima
//
//  Created by Miko Arce on 2018-03-19.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

class JSONKeys {
    lazy static let KEY_TEMP_INFO = "main"
    lazy static let KEY_HUMIDITY = "humidity"
    lazy static let KEY_PRESSURE = "pressure"
    lazy static let KEY_CURR_TEMP = "temp"
    lazy static let KEY_MAX_TEMP = "temp_max"
    lazy static let KEY_MIN_TEMP = "temp_min"
    
    lazy static let KEY_LOCATION_INFO = "sys"
    lazy static let KEY_LOCATION_NAME = "name"
    lazy static let KEY_COUNTRY = "country"
    lazy static let KEY_SUNRISE = "sunrise"
    lazy static let KEY_SUNSET = "sunset"
    
    lazy static let KEY_WEATHER_INFO = "weather"
    lazy static let KEY_WEATHER_DESCRIPTION = "description"
    lazy static let KEY_WEATHER_SUMMARY = "main"
    
    lazy static let KEY_WIND_INFO = "wind"
    lazy static let KEY_SPEED = "speed"
}
