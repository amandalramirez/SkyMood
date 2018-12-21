//
//  ViewController.swift
//  SkyMood
//
//  Created by Amanda Ramirez on 10/19/18.
//  Copyright © 2018 Amanda Ramirez. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

@IBDesignable
class WeatherMainVC: UIViewController, CLLocationManagerDelegate {

    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "66f3e33d79559da127ea635764c04704"
    
    //Instance variables
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    
    //IBOutlets
    @IBOutlet weak var currentTempLabel: UILabel!
    
    //all weather icons
    //city label
    //all temperature labels
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Location Manager set-up.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() //runs in the background, sends info back to this location delegate view controller
    
    }

    
    
    //MARK: - Networking (will make the HTTP request to the website servers)
    /* ************************************** */
    func getWeatherData(url: String, parameters: [String : String]) {
        
        //Alamofire makes a request in the background
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success in getting weather data")
                
                let weatherData : JSON = JSON(response.result.value!)
                updateWeatherData(json: weatherData)
                
            } else {
                print("Error \(response.result.error)")
                self.currentTempLabel.text = "?"
            }
        }
    
        
        
    //MARK: - JSON Parsing (will parse the response we get from API into something we can display in the app)
    /* ************************************** */
    func updateWeatherData(json : JSON) {
        
        let tempResult = json["main"]["temp"].double //this temperature is expressed in Kelvins
        weatherDataModel.temperature = Int(tempResult! - 273.15) //must subtract 273.15 to get Celcius
        
        weatherDataModel.city = json["name"].stringValue
        
        weatherDataModel.condition = json["weather"][0]["id"].intValue
    }
    
        
        
    //MARK: - UI Updates
    /* ************************************** */
    func updateUIWithWeatherData() {
        
    }
    
    //MARK: - Location Manager Delegate Methods (will grab the location)
    /* ************************************** */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        //check if location is valid
        if location.horizontalAccuracy > 0 {
            self.locationManager.stopUpdatingLocation()
            // in order to get the data back once, until Location Manager stops updating
            self.locationManager.delegate = nil
            
            //create String constaants containing the coordinates of the location, to pass into API url call
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
        
    
    //Error can happen for any # of reasons: user is in airplane mode, has no internet, etc
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        currentTempLabel.text = "?"
    }
    
    //MARK: - Change City Delegate Methods (handles how we can change from one view controller to the other, and how to pass data back and forth between those controlllers)
    /* ************************************** */
    func userEnteredANewCity() {
        
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    //Custom Segmented Control - when user clicks on a button, what action takes place (which information shows up)
    /* ************************************** */
    @IBAction func customSegValueChanged(_ sender: CustomSegControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            // 1st segment - 'TODAY'
            UIView.animate(withDuration: 0.3, animations: {
                self.todayView = .identity
            })
        default:
            // 2nd segment - 'FUTURE'
            UIView.animate(withDuration: 0.3, animations: {
                self.futureView = .identity
            })
        }
        
    }
    
    
    
    
}

