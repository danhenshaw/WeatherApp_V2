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
    var languageLong = ""
    
    var units = ""
    var unitsLong = ""
    
    var settingsHaveChanged = false
    var fontSizemultiplier = 1.0
    var precipBlue = 0x00abff
    
    
    var currentlyData : [ForecastDataType] = [.temp, .feelsLike, .precipProbability, .humidity, .pressure]
    var hourlyData : [ForecastDataType] = [.feelsLike, .precipProbability, .humidity, .pressure, .dewPoint, .wind, .uvIndex, .ozone]
    var dailyData : [ForecastDataType] = [.feelsLike, .precipProbability, .humidity, .pressure, .dewPoint, .wind, .sunriseTime, .sunsetTime]


    mutating func setFontSizeMultipler(screenHeight: Double) {
        fontSizemultiplier = screenHeight / 568
    }
    
    
    mutating func update(value: PickerType, toNewValue: String) {
        switch value {
        case .forecast : print("Saving forecast settings not yet available")
        case .language :
            UserDefaults.standard.set(toNewValue, forKey: "LanguageKey")
            language = toNewValue
            languageLong = Translator().getString(forLanguage: language, string: "language")
        case .units :
            UserDefaults.standard.set(toNewValue, forKey: "UnitsKey")
            units = toNewValue
            unitsLong = Translator().getString(forLanguage: units, string: "units")
        }
    }
    
    mutating func haveSettingsChanged(_ value: Bool) {
        settingsHaveChanged = value
    }

    func getDefaultLongName(value: PickerType) -> String {
        let translator = Translator()
        switch value {
        case .forecast : return ""
        case .language : return translator.getString(forLanguage: language, string: "language")
        case .units : return translator.getString(forLanguage: language, string: "units")
        }
    }

}
