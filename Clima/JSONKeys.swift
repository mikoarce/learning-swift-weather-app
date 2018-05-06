//
//  JSONDictKeys.swift
//  Clima
//

import Foundation

class JSONKeys {
    // Temperature keys
    static let tempInfoKey = "main"
    static let humidityKey = "humidity"
    static let pressureKey = "pressure"
    static let currTempKey = "temp"
    static let maxTempKey = "temp_max"
    static let minTempKey = "temp_min"
    // Location based keys
    static let locInfoKey = "sys"
    static let cityNameKey = "name"
    static let countryKey = "country"
    static let sunriseKey = "sunrise"
    static let sunsetKey = "sunset"
    // Weather summary Keys
    static let weatherInfoKey = "weather"
    static let weatherDescriptionKey = "description"
    static let weatherSummaryKey = "main"
    static let weatherIdKey = "id"
    //Wind keys
    static let windInfoKey = "wind"
    static let windSpeedKey = "speed"
}
