//
//  TodayViewController.swift
//  Widget
//
//  Created by Daniel Henshaw on 19/2/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//


// 1. Retrieve the current location if possible
//      1a. If location services are not enabled, show button to redirect to settings
// 2. Check if we current city is the same as current city from core data
//      2a. If no, fetch new forecast
//      2b. If yes, move to step 2
// 3. Check to see if we should download new forecast based on time elapsed since previous download
//      3a. If sufficient time has passed, download new forecast
//      3b. if insufficient time has passed, load forecast from core data

import UIKit
import NotificationCenter

@objc(TodayViewController)
class TodayViewController: UIViewController, NCWidgetProviding {
    
    var currentCity: CityDataModel?
    var previousCity: CityDataModel?
    
    var currentForecast: ForecastModel?
    var previousForecast: ForecastModel?
    
    override func loadView() { view = TodayView() }
    
    var todayView: TodayView { return self.view as! TodayView }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        restoreUserSettingsFromStorage()
        loadFromCoreData()
        startUpdatingLocation()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        saveToCoreData()
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
            self.todayView.updateView(expand: false)
        } else if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 150)
            self.todayView.updateView(expand: true)
        }
    }

    func restoreUserSettingsFromStorage() {
        //TODO : Create a shared container for UserDefaults(suiteName:) to share data (language and units)
        print("restoreUserSettingsFromStorage")
    }
    
    func loadFromCoreData() {
        // TODO: Create a shared container for core data and load previous city and forecast data
        print("loadFromCoreData")
    }
    
    func saveToCoreData() {
        // TODO: Create a shared container for core data and save current city and forecast data
        print("saveToCoreData")
    }
    
    
    func startUpdatingLocation() {
        LocationManager().requestLocation { (currentLocation, error) in
            if let error = error { print("There was an error fetching the current location: ", error) }
            
            if let currentLocation = currentLocation {
                print("Success! We have the current location")
                let cityData = CityDataModel()
                cityData.latitude = currentLocation.latitude
                cityData.longitude = currentLocation.longitude
                cityData.cityName = currentLocation.cityName
                cityData.isCurrentLocation = true
                self.currentCity = cityData
                self.getCityName()
            }
        }
    }
    
    
    func getCityName() {
        if let currentCity = currentCity {
            LocationManager().requestCityName(latitude: currentCity.latitude, longitude: currentCity.longitude) { (cityName, error) in
                if let error = error { print("Error getting city name:", error) }
                if let cityName = cityName {
                    print("Success! We retrieved the city name: ", cityName)
                    self.currentCity?.cityName = cityName
                    self.checkToSeeIfShouldUpdateForecast()
                }
            }
        }
    }
    
    
    func checkToSeeIfShouldUpdateForecast() {
        
        let currentTime = Int(Date().timeIntervalSince1970)
        let previousForecastDownloadedTime = previousForecast?.currently?.time ?? 0

        if currentCity?.cityName == previousCity?.cityName && currentTime <= (previousForecastDownloadedTime + 2 * 60 * 60) {
            print("SAME CITY AND INSUFFICIENT TIME SINCE PREVIOUS DOWNLOAD.")
            currentForecast = previousForecast
            updateViewData()
        } else {
            print("NEW CITY OR SUFFICIENT TIME SINCE PREVIOUS DOWNLOAD")
            fetchForecast()
        }
    }
    
    
    func fetchForecast() {
        if let currentCity = currentCity {
            DarkSkyAPI().fetchWeather(latitude: currentCity.latitude, longitude: currentCity.longitude) { (retrievedForecast, error) in
                if let error = error { print("There was an error retrieving the forecast:", error) }
                if retrievedForecast != nil {
                    print("Success! We retrieved the forecast.")
                    self.currentForecast = retrievedForecast
                    self.updateViewData()
                }
            }
        }
    }
    
    
    func updateViewData() {
        DispatchQueue.main.async() {
            
            var cityName = ""
            var data: TodayViewItem
            
            if let cityData = self.currentCity { cityName = cityData.cityName }
            
            if let forecast = self.currentForecast {
                
                let timeZone = forecast.timezone ?? ""
                let defatultCell = LabelFormat(title: "--", value: "--")
                
                data = TodayViewItem(currentTemp: forecast.currently?.getValueString(dataType: "temp", timeZone: timeZone).value ?? "",
                                     values: [LabelFormat(title: cityName, value: forecast.currently?.summary ?? "--"),
                                              forecast.currently?.getValueString(dataType: "precipProbability", timeZone: timeZone) ?? defatultCell,
                                              forecast.currently?.getValueString(dataType: "humidity", timeZone: timeZone) ?? defatultCell,
                                              forecast.currently?.getValueString(dataType: "wind", timeZone: timeZone) ?? defatultCell ])
  
                self.todayView.bindWith(data)
                
            }
        }
    }
}
