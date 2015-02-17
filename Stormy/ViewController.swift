//
//  ViewController.swift
//  Stormy
//
//  Created by Hannah Gibson on 12/6/14.
//  Copyright (c) 2014 Hannah Gibson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var RefreshButton: UIButton!
   
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func Refresh(sender: AnyObject) {
        RefreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        //unhides activity indicator and hides button
    refreshActivityIndicator.startAnimating()
    //animates indicator
    getCurrentWeatherData()
    }
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var humidity: UILabel!
    
    @IBOutlet weak var chanceOfRain: UILabel!
    
    @IBOutlet weak var summary: UILabel!
    
    private let apiKey = "966e100d59cb71b3258e685a519a5421" //keyword private restricts access to varible to it's source file

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshActivityIndicator.hidden = true
        //hides refresh activity indicator
      getCurrentWeatherData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func getCurrentWeatherData() {
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forcastURL = NSURL(string: "42.358760, -71.106727", relativeToURL: baseURL)!
        //since only the location changes, not apiKey and other parts of URL, can use this method
        //var weatherData = NSData(countentsOfURL: forcastURL, options: nil, error: nil) This fetches data syncronously, don't want to use
        //JSON: JavaScript Object Notation: prefered method of webApp data transfer. Represented with collection of key-value pairs (similar to NSDictionary or hash table) and Ordered list of values (similar to NSArray). Data from forcast query structured as
        //session object gets data asycronusly. sharedSession is a singleton: allows only creation of each object, all other initializations return same object. This object will share across entire app
        let sharedSession = NSURLSession.sharedSession()
        //creates tasks
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forcastURL, completionHandler: {(location: NSURL!/*location where data stored*/, response: NSURLResponse!/*downLoad information*/, error: NSError!/*error response*/) in
            if (error == nil) {
                let dataObject = NSData(contentsOfURL: location)//creates data object
                let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary //creates JSON data object from NSDATA object
                let currentWeather = Current(weatherDictionary: weatherDictionary)
                //function that submits block of code to main quay managed by central dispatch manager. Takes queue and code. In this case main queue
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //Closure with updates to be made to UI
                    self.iconView.image = currentWeather.icon
                    self.humidity.text = "\(currentWeather.temperature)"
                    self.chanceOfRain.text = "\(currentWeather.percipitationProbability)"
                    self.summary.text = "\(currentWeather.summary)"
                    self.currentTimeLabel.text = "At \(currentWeather.currentTime!) the weather is"
                    self.refreshActivityIndicator.stopAnimating()
                    //stops animating indicator when data is added to view
                    self.refreshActivityIndicator.hidden = true
                    self.RefreshButton.hidden = false
                    //shows button and hides indicator again
                })
            } else {
        //creates alert controller object with okay and cancel buttons
        let networkIssueController = UIAlertController(title: "Opps, Something went wrong!", message: "Unable to load data. Check your internet connection", preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        networkIssueController.addAction(okButton)
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        networkIssueController.addAction(cancelButton)
        self.presentViewController(networkIssueController, animated: true, completion: nil)
            //displays an error message if their is an error
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.refreshActivityIndicator.stopAnimating()
        self.refreshActivityIndicator.hidden = true
        self.RefreshButton.hidden = false
            })
        }
    }) //closure caputures varibles so can use when call complete. UTF8 common string encoder
    downloadTask.resume() //starts
        
    }
}

//concurency: running UI interface in foreground and other tasks (such as the netwrokin query in background)
//Grand Central Dispatch: takes thread creation and pushed to machine level. When we make an asycronus call we dispatch to background thread closures do this. General syntax: { (parameters) -> return type in statements}
//Ex. Anminations: UIView.animateWithDuration(1.0, animations: { //some code} completion: {(value: Bool) in //some completion handeler})


