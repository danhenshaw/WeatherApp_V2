//
//  ViewModel.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 17/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import Foundation
import CoreLocation


class InitialViewModel {
    
    fileprivate var coreDataManager: CoreDataManager
    var cityData: [CityDataModel]!
    
    struct DefaultSettings {
        static let language = "en"
        static let units = "us"
        static let currentData = ["temp", "feelsLike", "precipProbability", "humidity", "wind"]
        static let hourlyData = ["feelsLike", "precipProbability", "humidity", "wind", "pressure", "dewPoint", "cloudCover", "uvIndex"]
        static let dailyData = ["feelsLike", "precipProbability", "humidity", "wind", "uvIndex", "ozone", "sunriseTime", "sunsetTime"]
    }

    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        cityData = [CityDataModel]()
        restoreUserSettingsFromStorage()
        getLocationsFromCoreData()
    }
    
    
    
    func restoreUserSettingsFromStorage() {
        
        let availableLanguages = ["en", "es", "fr", "it", "ja", "tr", "x-pig-latin", "zh", "zh-tw"]
        let systemLanguage = NSLocale.current.languageCode ?? DefaultSettings.language
        let appLanguage = UserDefaults.standard.string(forKey: GlobalVariables.sharedInstance.languageKey)
        
        if appLanguage != nil {
            GlobalVariables.sharedInstance.update(value: .language, forecastSection: nil, slot: nil, toNewValue: appLanguage ?? DefaultSettings.language)
        } else if availableLanguages.contains(systemLanguage) {
            GlobalVariables.sharedInstance.update(value: .language, forecastSection: nil, slot: nil, toNewValue: systemLanguage)
        } else {
            GlobalVariables.sharedInstance.update(value: .language, forecastSection: nil, slot: nil, toNewValue: DefaultSettings.language)
        }
        
        let units = UserDefaults.standard.string(forKey: GlobalVariables.sharedInstance.unitsKey)
        GlobalVariables.sharedInstance.update(value: .units, forecastSection: nil, slot: nil, toNewValue: units ?? DefaultSettings.units)
        
        for index in 0 ..< GlobalVariables.sharedInstance.currentDataKeys.count {
            let currentDataType = UserDefaults.standard.string(forKey: GlobalVariables.sharedInstance.currentDataKeys[index])
            GlobalVariables.sharedInstance.update(value: .forecast, forecastSection: .currently, slot: index, toNewValue: currentDataType ?? DefaultSettings.currentData[index])
        }
        
        for index in 0 ..< GlobalVariables.sharedInstance.hourlyDataKeys.count {
            let hourlyDataType = UserDefaults.standard.string(forKey: GlobalVariables.sharedInstance.hourlyDataKeys[index])
            GlobalVariables.sharedInstance.update(value: .forecast, forecastSection: .hourly, slot: index, toNewValue: hourlyDataType ?? DefaultSettings.hourlyData[index])
        }
        
        for index in 0 ..< GlobalVariables.sharedInstance.dailyDataKeys.count {
            let dailyDataType = UserDefaults.standard.string(forKey: GlobalVariables.sharedInstance.dailyDataKeys[index])
            GlobalVariables.sharedInstance.update(value: .forecast, forecastSection: .daily, slot: index, toNewValue: dailyDataType ?? DefaultSettings.dailyData[index])
        }

    }
    
    func getLocationsFromCoreData() {
        cityData = coreDataManager.getAllCityData()
    }
    
}



