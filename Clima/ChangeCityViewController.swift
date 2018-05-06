//
//  ChangeCityViewController.swift
//  WeatherApp
//

import UIKit

protocol CityWeatherInfoDelegate: class {
    func getWeatherInfoOf(location: String)
}

class ChangeCityViewController: UIViewController {
    @IBOutlet weak var changeCityTextField: UITextField!

    weak var delegate: CityWeatherInfoDelegate?

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
