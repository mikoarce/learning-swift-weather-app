//
//  OpenWeatherMapService.swift
//  Clima
//
//  Created by Miko Arce on 2018-03-24.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import Alamofire

class OpenWeatherMapService {
    private let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    private let APP_ID = ApiKeys.OPEN_WEATHER_API_KEY
    
    func getWeatherInfoWith(latitude: Double, longitude: Double, completion: @escaping (NSDictionary?) -> ()) {
        let urlAsString = "\(WEATHER_URL)?lat=\(latitude)&lon=\(longitude)&appid=\(APP_ID)"
        send(url: urlAsString, completion: completion)
    }
    
    func getWeatherInfoWith(locationName: String, completion: @escaping (NSDictionary?) -> ()) {
        let newLocation = locationName.replacingOccurrences(of: " ", with: "+")
        let urlAsString = "\(WEATHER_URL)?q=\(newLocation)&appid=\(APP_ID)"
        send(url: urlAsString, completion: completion)
    }
    
    private func send(url urlAsString: String, completion: @escaping (NSDictionary?) -> ()) {
        let url = URL(string: urlAsString)
        print("URL: \(urlAsString)")
        
        if let urlToSend = url {
            Alamofire.request(urlToSend, method: .get).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let jsonDict = value as! NSDictionary
                    completion(jsonDict)
                case .failure(let error):
                    NSLog("URL ERROR: ", "Error [\(error)] due to failed URL: \(urlAsString)")
                    completion(nil)
                }
            }
        }
    }
}
