//
//  OpenWeatherMapService.swift
//  Clima
//


import Foundation
import Alamofire

class OpenWeatherMapService {
    private let weatherUrl = "http://api.openweathermap.org/data/2.5/weather"
    private let appId = ApiKeys.openWeatherApiKey

    func getWeatherInfoWith(latitude: Double, longitude: Double, completion: @escaping (NSDictionary?) -> Void) {
        let urlAsString = "\(weatherUrl)?lat=\(latitude)&lon=\(longitude)&appid=\(appId)"
        send(url: urlAsString, completion: completion)
    }

    func getWeatherInfoWith(locationName: String, completion: @escaping (NSDictionary?) -> Void) {
        let newLocation = locationName.replacingOccurrences(of: " ", with: "+")
        let urlAsString = "\(weatherUrl)?q=\(newLocation)&appid=\(appId)"
        send(url: urlAsString, completion: completion)
    }

    private func send(url urlAsString: String, completion: @escaping (NSDictionary?) -> Void) {
        let url = URL(string: urlAsString)
        print("URL: \(urlAsString)")

        if let urlToSend = url {
            Alamofire.request(urlToSend, method: .get).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let jsonDict = value as? NSDictionary
                    completion(jsonDict)
                case .failure(let error):
                    NSLog("URL ERROR: ", "Error [\(error)] due to failed URL: \(urlAsString)")
                    completion(nil)
                }
            }
        }
    }
}
