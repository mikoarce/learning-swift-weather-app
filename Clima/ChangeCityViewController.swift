//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

protocol CityWeatherInfoDelegate {
    func getWeatherInfoOf(location: String)
}

class ChangeCityViewController: UIViewController {
    var delegate: CityWeatherInfoDelegate?
    
    @IBOutlet weak var changeCityTextField: UITextField!

    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        if let input = changeCityTextField.text, input.count > 0 {
            delegate?.getWeatherInfoOf(location: input)
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
