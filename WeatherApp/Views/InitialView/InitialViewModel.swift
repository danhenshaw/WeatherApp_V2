//
//  ViewModel.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 17/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import Foundation
import CoreLocation

protocol InitialViewModelDelegate: class {
    func viewModel(_ viewModel: InitialViewModel, didEnableLocationServices currentLocation: CLLocation)
    func viewModel(_ viewModel: InitialViewModel, didSetDefaultLocation defaultLocation: CLLocation)
}


class InitialViewModel {
    
    weak var delegate: InitialViewModelDelegate?
    fileprivate var coreDataManager: CoreDataManager
    var cityData: [CityDataModel]!
    
    struct DefaultSettings {
        static let language = "en" //NSLocale.current.languageCode ?? "en"
        static let units = "us"
        static let currentData = ["temp", "feelsLike", "precipProbability", "humidity", "wind"]
        static let hourlyData = ["temp", "precipProbability", "humidity", "wind", "pressure", "dewPoint", "cloudCover", "uvIndex"]
        static let dailyData = ["temp", "precipProbability", "humidity", "wind", "uvIndex", "ozone", "sunriseTime", "sunsetTime"]
    }

    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        cityData = [CityDataModel]()
        restoreUserSettingsFromStorage()
        getLocationsFromCoreData()
    }
    
    
    func restoreUserSettingsFromStorage() {
        let language = UserDefaults.standard.string(forKey: GlobalVariables.sharedInstance.languageKey) ?? DefaultSettings.language
        GlobalVariables.sharedInstance.update(value: .language, forecastSection: nil, slot: nil, toNewValue: language)
        
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



