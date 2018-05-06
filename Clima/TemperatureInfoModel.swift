//
//  TemperatureDataModel.swift
//  Clima
//

import Foundation

protocol TemperatureConversionProtocol {
    var tempMinAsCelsius: Double? { get }
    var tempMinAsFahrenheit: Double? { get }
    var tempMaxAsCelsius: Double? { get }
    var tempMaxAsFahrenheit: Double? { get }
    var currTempAsCelsius: Double? { get }
    var currTempAsFahrenheit: Double? { get }
}

struct TemperatureInfo {
    let humidity: Int?
    let pressure: Int?
    let tempMin: Double?
    let tempMax: Double?
    let currTemp: Double?

    private func convertTemperatureToCelsius(fromKelvin temp: Double?) -> Double? {
        guard let temp = temp else {
            return nil
        }
        return temp - 273.15
    }

    private func convertTemperatureToFahrenheit(fromKelvin temp: Double?) -> Double? {
        guard let temp = temp, let tempInCelsius = convertTemperatureToCelsius(fromKelvin: temp) else {
            return nil
        }
        return (9.0/5.0) * tempInCelsius + 32.0
    }
}

extension TemperatureInfo: TemperatureConversionProtocol {
    var tempMinAsCelsius: Double? {
        return convertTemperatureToCelsius(fromKelvin: tempMin)
    }

    var tempMinAsFahrenheit: Double? {
        return convertTemperatureToFahrenheit(fromKelvin: tempMin)
    }

    var tempMaxAsCelsius: Double? {
        return convertTemperatureToCelsius(fromKelvin: tempMax)
    }

    var tempMaxAsFahrenheit: Double? {
        return convertTemperatureToFahrenheit(fromKelvin: tempMax)
    }

    var currTempAsCelsius: Double? {
        return convertTemperatureToCelsius(fromKelvin: currTemp)
    }

    var currTempAsFahrenheit: Double? {
        return convertTemperatureToFahrenheit(fromKelvin: currTemp)
    }
}
