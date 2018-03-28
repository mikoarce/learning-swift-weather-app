Notes
-----
What's written down in this area is just to note down what I <del>learned</del> need to remember from these mini projects that I do. Although some project ideas like this were taken from a [Udemy course](https://www.udemy.com/ios-11-app-development-bootcamp/learn/v4/overview) I'm following, I'd rather just take the assets (and skeleton code) and try to do it myself. If you're a Swift beginner like me, you should do it too!

Coming from a Java background, a lot of these new and *Swift-y* approaches are odd, really really odd, but in a pleasingly good way. Swift is definitely not chunky and it is incredibly soothing to the eyes. It gets you all giddy which makes it borderline cute. It's programmatically therapeutic.

Anyhow, these notes will briefly talk about three of the most important features of Swift I ended up using in this project and how it was implemented:

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

Closures for capturing data in ```async``` blocks
- 
File/s referenced from this project:  

 * [OpenWeatherMapService.swift](https://github.com/mikoarce/learning-swift-weather-app/blob/master/Clima/OpenWeatherMapService.swift)
 * [WeatherViewController.swift](https://github.com/mikoarce/learning-swift-weather-app/blob/master/Clima/WeatherViewController.swift)


Closures are, in essence, blocks of code that can be passed as parameters. According to Apple's documentation:
> Closures are self-contained blocks of functionality that can be passed around and used in your code. Closures in Swift are similar to blocks in C and Objective-C and to lambdas in other programming languages.

You can read a more comprehensive explanation on closures and what they're all about but what I want to focus on is how we can use closures capturing data from asynchronous blocks of code.  

Alamofire and the asynchronous response
---
[Alamofire](https://github.com/Alamofire/Alamofire) is a great library you can use for your HTTP networking needs. Personally, I used it to send get requests and retrieve responses as JSON objects. A typical request with Alamofire will look something like this:

```swift
private func send(url urlAsString: String) {
    let url = URL(string: urlAsString)
    
    if let urlToSend = url {
        Alamofire.request(urlToSend, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonDict = value as! NSDictionary
                //Handle your jsonDict
            case .failure(let error):
                NSLog("URL ERROR: ", "Error [\(error)] from URL: \(urlAsString)")
                //Handle error scenario
            }
        }
    }
}
```

You can toss in a method for handling jsonDict while inside the `.success` switch condition but that would make it tightly coupled. It's in a `send` method, so it is at the very least expected to be reusable. 

Capturing Alamofire Data Woes
----
We can't return `jsonDict` directly from inside the switch case because the data is inside a closure from `.responseJSON` which returns `Void`:

```swift
Alamofire.request(urlToSend, method: .get).validate()
            .responseJSON(completionHandler: (DataResponse<Any>) -> Void)
```

What about declaring a variable outside the Alamofire block and use that instead of `jsonDict` so we can return the value like so:

```swift
private func send(url urlAsString: String) -> NSDictionary? {
    let url = URL(string: urlAsString)
    var jsonDict: NSDictionary? = nil //declare it
    
    if let urlToSend = url {
        Alamofire.request(urlToSend, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                jsonDict = value as! NSDictionary //assign it
                //Handle your jsonDict
            case .failure(let error):
                NSLog("URL ERROR: ", "Error [\(error)] from URL: \(urlAsString)")
                //Handle error scenario
            }
        }
    }
    return jsonDict //return it
}

```
Doing this, however, will always have your `send` method return `nil`. The reason is because all the way inside `responseJSON` shows that we're actually handling our value inside an asynchronous block:

```swift
public func response<T: DataResponseSerializerProtocol>(
        queue: DispatchQueue? = nil,
        responseSerializer: T,
        completionHandler: @escaping (DataResponse<T.SerializedObject>) -> Void)
        -> Self
    {

    delegate.queue.addOperation {
	    ...

	    (queue ?? DispatchQueue.main).async { completionHandler(dataResponse) }

	    ...
	}
}
    
```
 
By definition, an asynchronous block is called in a separate thread without blocking the current thread. This is why merely assigning the value to a variable from outside the Alamofire method will not update anything because passing data in multiple threads doesn't work that way. The solution is to take advantage of closures!

The Solution: Closures
----
One way to retrieve data from an asynchronous block is to use closures in capturing data. We can first create our method that captures data from the async block by changing the parameters to:

```swift
func send(url urlAsString: String, completion: @escaping (NSDictionary?) -> ()) {
	...
}
```

We then can call `completion(NSDictionary?)` like a method while inside `send(...)`:

```swift
func send(url urlAsString: String, completion: @escaping (NSDictionary?) -> ()) {
	let url = URL(string: urlAsString)
        print("URL: \(urlAsString)")
        
        if let urlToSend = url {
            Alamofire.request(urlToSend, method: .get).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let jsonDict = value as! NSDictionary
                    completion(jsonDict)
                case .failure(let error):
                    NSLog("URL ERROR: ", "Error [\(error)] from URL: \(urlAsString)")
                    completion(nil)
                }
            }
        }
}
```

Calling `completion(jsonDict)` this way would pass the `jsonDict` value *upward* to where `send(...)` was called. We then access `jsonDict` through what is called the closure expression syntax:

```swift
send(url: "myUrlString") { (jsonDict) in
    //Do what you want with jsonDict, an NSDictionary from the asynchronous block
}
```

The Solution: Nested/Chaining Closures
----
There are times however when you would want to double up your upward passes to a more descriptive method compared to just `send(...)`. But since we used closures to access asynchronous data, this is where chaining is required. We can chain our closures by creating another method that passes a closure to `send(...)`.

```swift
//Inside WeatherViewController class
func getWeatherInfoOf(location: String) {
    openWeatherMapService.getWeatherInfoWith(locationName: location) { (jsonDict) in
        if let jsonDict = jsonDict {
            let weatherDataModel = WeatherDataModel(jsonDict)
            self.populateWeatherDataUI(withData: weatherDataModel)
        } else {
            self.handleError()
        }
    }
}

//Inside OpenWeatherMapService class
func getWeatherInfoWith(locationName: String, completion: @escaping (NSDictionary?) -> ()) {
    let newLocation = locationName.replacingOccurrences(of: " ", with: "+")
    let urlAsString = "\(WEATHER_URL)?q=\(newLocation)&appid=\(APP_ID)"
    send(url: urlAsString, completion: completion)
}

func send(url urlAsString: String, completion: @escaping (NSDictionary?) -> ()) {
	//Inside asynchronous block:
		completion(/* pass your NSDictionary? here */) 
	//End of asynchronous block.
}
```

Below is a step by step process on what happens once `WeatherViewController.getWeatherInfoOf(String)` is called:

1. `getWeatherInfoWith(locationName: String, completion: @escaping (NSDictionary?) -> ())` is called.
2. While inside `OpenWeatherMapService.getWeatherInfoWith(...)`, `send(...)` gets called taking in the closure of `.getWeatherInfoWith(...)`.
3. `send(...)` method calls `completion(NSDictionary?)`, which passes back your NSDictionary up to `OpenWeatherMapService.getWeatherInfoWith(...)`.
4. At this point `jsonDict` has been captured from the asynchronous block all the way up to `WeatherViewController.getWeatherInfoOf(...)` where we can finally use and manipulate it.

Closures in Swift is quite a lengthy topic and capturing values from asynchronous blocks is only one practical use for it. There are different ways of utilizing closures like trailing closures and array sorting all found in Apple's comprehensive [documentation](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Closures.html).
