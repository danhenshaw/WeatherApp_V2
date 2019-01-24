//
//  GlobalVariables.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 20/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import UIKit

struct GlobalVariables {
    
    static var sharedInstance = GlobalVariables()
    
    var language = ""
    var units = ""
    
    var settingsHaveChanged = false
    var fontSizemultiplier = 1.0
    var precipBlue = 0x00abff
    
    var currentlyData = Array(repeating: "", count: 5)
    var hourlyData = Array(repeating: "", count: 8)
    var dailyData = Array(repeating: "", count: 8)
    
    
    let languageKey = "LanguageKey"
    let unitsKey = "UnitsKey"
    let currentDataKeys = ["CurrentDataKey0", "CurrentDataKey1", "CurrentDataKey2", "CurrentDataKey3", "CurrentDataKey4"]
    let hourlyDataKeys = ["HourlyDataKey0", "HourlyDataKey1", "HourlyDataKey2", "HourlyDataKey3", "HourlyDataKey4", "HourlyDataKey5", "HourlyDataKey6", "HourlyDataKey7"]
    let dailyDataKeys = ["DailyDataKey0", "DailyDataKey1", "DailyDataKey2", "DailyDataKey3", "DailyDataKey4", "DailyDataKey5", "DailyDataKey6", "DailyDataKey7"]
    
    
    mutating func setFontSizeMultipler(screenHeight: Double) {
        fontSizemultiplier = screenHeight / 568
    }
    
    
    mutating func update(value: PickerType, forecastSection: ForecastSection?, slot: Int?, toNewValue: String) {
        switch value {
        case .forecast :
            
            if let forecastSection = forecastSection {
                if let slot = slot {
                    switch forecastSection {
                    case .currently :
                        currentlyData[slot] = toNewValue
                        UserDefaults.standard.set(toNewValue, forKey: currentDataKeys[slot])
                    case .daily :
                        dailyData[slot] = toNewValue
                        UserDefaults.standard.set(toNewValue, forKey: dailyDataKeys[slot])
                    case .hourly :
                        hourlyData[slot] = toNewValue
                        UserDefaults.standard.set(toNewValue, forKey: hourlyDataKeys[slot])
                    default: break
                    }
                }
            }

        case .language :
            UserDefaults.standard.set(toNewValue, forKey: languageKey)
            language = toNewValue
        case .units :
            UserDefaults.standard.set(toNewValue, forKey: unitsKey)
            units = toNewValue
        }
    }
    
    mutating func haveSettingsChanged(_ value: Bool) {
        settingsHaveChanged = value
    }

}
