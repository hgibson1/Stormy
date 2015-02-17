//
//  Current.swift
//  Stormy
//
//  Created by Hannah Gibson on 12/6/14.
//  Copyright (c) 2014 Hannah Gibson. All rights reserved.
//

import Foundation
import UIKit
struct Current {
    
    //converts the time to human readable time
    func dateStringFromUnixTime(unixTime: Int) -> (String){
        let time = NSTimeInterval(unixTime)
        let date = NSDate(timeIntervalSinceReferenceDate: time) //converts time in seconds to a date using the time in seconds method
        let dateFormatter = NSDateFormatter()//initalizes instance of date formater class to display date
        dateFormatter.timeStyle =  .MediumStyle
        return dateFormatter.stringFromDate(date)
    }
    
    //initialization.
    var currentTime : String?
    var temperature: Int
    var humidity: Double
    var percipitationProbability: Double
    var summary: String
    var icon: UIImage?
    
    //initializor method. Like an instance method with no parameters or return values. Use "init" keyword. Init(){} is standard
    //designated initializor
    init(weatherDictionary: NSDictionary){
        let currentWeather = weatherDictionary["currently"] as NSDictionary
        temperature = currentWeather["temperature"] as Int
        humidity = currentWeather["humidity"] as Double
        percipitationProbability = currentWeather["precipProbability"] as Double
        summary = currentWeather["summary"] as String
        let timeInt = currentWeather["time"] as Int
        currentTime = dateStringFromUnixTime(timeInt) as String
        //need to unwrap before use since is an optional
        let iconString = currentWeather["icon"] as String
        let icon = weatherIconFromString(iconString)
    }
    
//Code to import images. Need to import images with the names in the switch statement. The conditions come from the Weather data for developers site
 func weatherIconFromString(stringIcon: String) ->(UIImage) {
    var imageNamed: String
    switch stringIcon {
        case "clear-day":
            imageNamed = "clear-day"
        case "clear-night":
            imageNamed = "clear-night"
        case "rain":
            imageNamed = "rain"
        case "snow":
            imageNamed = "snow"
        case "sleet":
            imageNamed = "sleet"
        case "wind":
            imageNamed = "wind"
        case "fog":
            imageNamed = "fog"
        case "cloudy":
            imageNamed = "cloudy"
        case "partly-cloudy-day":
            imageNamed = "partly-cloudy-day"
        case "partly-cloudy-night":
            imageNamed = "partly-cloudy-night"
    default:
        imageNamed = "default"
    }
    var iconImage = UIImage(named: imageNamed)
    return iconImage!
}

}
