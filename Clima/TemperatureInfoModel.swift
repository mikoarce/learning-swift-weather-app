//
//  TemperatureDataModel.swift
//  Clima
//


import Foundation

protocol TemperatureConversionProtocol {
    var tempMinAsCelsius: Float? { get }
    var tempMinAsFahrenheit: Float? { get }
    var tempMaxAsCelsius: Float? { get }
    var tempMaxAsFahrenheit: Float? { get }
    var currTempAsCelsius: Float? { get }
    var currTempAsFahrenheit: Float? { get }
}

struct TemperatureInfo {
    let humidity: Int?
    let pressure: Int?
    let tempMin: Float?
    let tempMax: Float?
    let currTemp: Float?
    
    private func convertTemperatureToCelsius(fromKelvin temp: Float?) -> Float? {
        guard let temp = temp else {
            return nil
        }
        return temp - 273.15
    }
    
    private func convertTemperatureToFahrenheit(fromKelvin temp: Float?) -> Float? {
        guard let temp = temp, let tempInCelsius = convertTemperatureToCelsius(fromKelvin: temp) else {
            return nil
        }
        return (9.0/5.0) * tempInCelsius + 32.0
    }
}

extension TemperatureInfo : TemperatureConversionProtocol {
    var tempMinAsCelsius: Float? {
        return convertTemperatureToCelsius(fromKelvin: tempMin)
    }
    
    var tempMinAsFahrenheit: Float? {
        return convertTemperatureToFahrenheit(fromKelvin: tempMin)
    }
    
    var tempMaxAsCelsius: Float? {
        return convertTemperatureToCelsius(fromKelvin: tempMax)
    }
    
    var tempMaxAsFahrenheit: Float? {
        return convertTemperatureToFahrenheit(fromKelvin: tempMax)
    }
    
    var currTempAsCelsius: Float? {
        return convertTemperatureToCelsius(fromKelvin: currTemp)
    }
    
    var currTempAsFahrenheit: Float? {
        return convertTemperatureToFahrenheit(fromKelvin: currTemp)
    }
}
