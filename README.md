Notes
-----
What's written down in this area is just to note down what I <del>learned</del> need to remember from these mini projects that I do. Although some project ideas like this were taken from a Udemy course I'm following, I'd rather just take the assets (and skeleton code) and try to do it myself. If you're a Swift beginner like me, you should do it too!

Coming from a Java background, a lot of these new and *Swift-y* approaches are odd, really really odd, but in a pleasingly good way. Swift is definitely not chunky and it is incredibly easy to the eyes. It gets you all giddy which makes it borderline cute.

Anyhow, these notes will briefly talk about three of the most important features of Swift and how it was implemented in the project. And these are:

 * [Protocols](https://github.com/mikoarce/learning-swift-weather-app#protocols)
 * [Delegates (through segue)](https://github.com/mikoarce/learning-swift-weather-app#delegates-through-segue)
 * [Closures](https://github.com/mikoarce/learning-swift-weather-app#closures)

Protocols
-----
File/s referenced from this project:  

 * [TemperatureInfoModel.swift](https://github.com/mikoarce/learning-swift-weather-app/blob/master/Clima/TemperatureInfoModel.swift)

Protocols are very much like Java interfaces. By Apple's definition, a protocol...
> defines a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality.

So just like what you would expect from a Java interface, protocol-class relationships may look something like this:

```swift
protocol MyProtocol {
	var myIntVariable: Int { get set }
	func myFunc()
}

class MyClass: MyProtocol {
	//Do class stuff
	
	var myIntVariable: Int {
		get {
			//Implement getter and return.
		}
		set {
			//Implement setter.
		}
	}
}
```

Aside from promoting reusability, the magic of protocols come with ```extension``` and delegates which will be talked about later. Extension, as the name implies, is a concept in Swift where you extend your class' members to make your models more organized.

For this project we have the structure ```TemperatureInfo``` which has info on the weather's temperature, humidity and pressure.

```swift
struct TemperatureInfo {
    let humidity: Int?
    let pressure: Int?
    let tempMin: Float?
    let tempMax: Float?
    let currTemp: Float?
    ...
}
```

The problem here is when we say ```currTemp```, is this in Kelvin, Celsius or Fahrenheit? We could add 3 ```currTemp```'s for each metric, or we could say have Kelvin as our default metric and ```extend``` our structure based on converting our temperatures to Celsius and Fahrenheit!

```swift
protocol TemperatureConversionProtocol {
    var tempMinAsCelsius: Float? { get }
    var tempMinAsFahrenheit: Float? { get }
    var tempMaxAsCelsius: Float? { get }
    var tempMaxAsFahrenheit: Float? { get }
    var currTempAsCelsius: Float? { get }
    var currTempAsFahrenheit: Float? { get }
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
```

With this approach your models are in a way more organized where everything isn't dumped into one giant model. But there's more to protocols than just organization. This brings us to...  

Delegates (through segue)
-----
File/s referenced from this project:  

 * [ChangeCityViewController.swift](https://github.com/mikoarce/learning-swift-weather-app/blob/master/Clima/ChangeCityViewController.swift)
 * [WeatherViewController.swift](https://github.com/mikoarce/learning-swift-weather-app/blob/master/Clima/WeatherViewController.swift)
 
Delegates are mainly used to transfer or pass data from one class to another, thus the term *delegation*. One popular example of a delegate is Apple's ```CLLocationManagerDelegate``` which enables you to check on your device's location (GPS). Another way a delegate was utilized in this project is when data from one ```ViewController``` should be transferred to another, through the use of segues.

In this project, we have ```WeatherViewController``` which contains the weather data and ```ChangeCityViewController``` where users can input a location to pull that area's weather info. It's bad UX but for delegate and segue learning purposes... it's alright.

**Step 1:** Create your protocol.  
We first create ```CityWeatherInfoDelegate``` which contains the method we'll be calling when the search button is selected.

```swift
protocol CityWeatherInfoDelegate {
    func getWeatherInfoOf(location: String)
}
```
**Step 2:** Declare your delegate and call the method.  
Declare the delegate as an optional in the class that calls the method (you'll see why later). This ViewController is also the end point of our segue.  

```swift
class ChangeCityViewController: UIViewController {
    @IBOutlet weak var changeCityTextField: UITextField!

    var delegate: CityWeatherInfoDelegate?
	...
}
```
 Once that's done, call its method to start the delegation:  
 
```swift
class ChangeCityViewController: UIViewController {
	...
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        if let input = changeCityTextField.text, input.count > 0 {
            delegate?.getWeatherInfoOf(location: input)
            ...
	}
}
```
 
**Step 3:** Implement the delegate's method in the recipient class:  
The recipient of the delegation in our case is the starting point of our segue. The ```WeatherViewController``` has a button that opens up a second screen connected to ```ChangeCityViewController```. We implement our delegate just like how we would do it with a protocol, we use ```extension```.

```swift
extension WeatherViewController : CityWeatherInfoDelegate {
    func getWeatherInfoOf(location: String) {
        openWeatherMapService.getWeatherInfoWith(locationName: location) { (jsonDict) in
            if let jsonDict = jsonDict {
                let weatherDataModel = WeatherDataModel(jsonDict)
                self.populateWeatherDataUI(withData: weatherDataModel)
            } else {
                self.handleError()
            }
        }
	...
    }
```

If we run our app at this point, you'll find that the button still doesn't call this implementation. The reason being is that the delegate in our source ViewController ```ChangeCityViewController``` wasn't initialized nor implemented but only declared. One final crucial step to complete the delegation is...  

**Step 4:** Override *prepareForSegue*  
The final step to close the connection is to have our delegate's starting point ViewController link to the recipient where the delegate's implementation is. Remember that for our case ```WeatherViewController``` has the segue to ```ChangeCityViewController```, but we want data from that ViewController to be transferred back to ```WeatherViewController``` on a button press. It's pretty much like how a callback acts.  

We can do that by overriding *prepareForSegue*. Don't forget to give your segue an identifier first!  

```swift
extension WeatherViewController : CityWeatherInfoDelegate {
	...
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let changeCityVC = segue.destination as! ChangeCityViewController
            changeCityVC.delegate = self
        }
    }
```
This snippet means that we are assigning the delegate implementation in ```WeatherViewController``` to the delegate we declared in **step 2** ```changeCityVC.delegate``` once segue with identifier "changeCityName" is pressed by the user. 

And there you have it! Following these steps will have the ```getWeatherInfoOf``` method in ```WeatherViewController``` run once called through ```delegate``` in ```ChangeCityViewController```.

Closures
-----
File/s referenced from this project:  

 * [OpenWeatherMapService.swift](https://github.com/mikoarce/learning-swift-weather-app/blob/master/Clima/OpenWeatherMapService.swift)
 * [WeatherViewController.swift](https://github.com/mikoarce/learning-swift-weather-app/blob/master/Clima/WeatherViewController.swift)  
 
Section in progress.

