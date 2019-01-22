//
//  UnitsModel.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 3/1/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import Foundation

enum UnitTypes {
    case pressure, distance, wind, rainfall, temperature
}

class UnitsModel {
    
    static let sharedInstance = UnitsModel()
    
    func getUnits(requestedUnits: UnitTypes) -> String {
        
        let language = "en" //GlobalVariables.sharedInstance.language
        let units = GlobalVariables.sharedInstance.units
        
        switch units {
        case "si" :
            switch requestedUnits {
            case .distance : return Translator.sharedInstance.getString(forLanguage: language, string: "kilometers") //km
            case .wind : return Translator.sharedInstance.getString(forLanguage: language, string: "metersPerSecond") //"m/s"
            case .rainfall : return Translator.sharedInstance.getString(forLanguage: language, string: "milimetersPerHour") //"mm/h"
            case .temperature : return Translator.sharedInstance.getString(forLanguage: language, string: "celcius") //"°C"
            case .pressure : return Translator.sharedInstance.getString(forLanguage: language, string: "pascals") //"hPa"
            }
        case "ca" :
            switch requestedUnits {
            case .distance : return Translator.sharedInstance.getString(forLanguage: language, string: "kilometers") //"km"
            case .wind : return Translator.sharedInstance.getString(forLanguage: language, string: "kilometersPerHour") //"km/h"
            case .rainfall : return Translator.sharedInstance.getString(forLanguage: language, string: "milimetersPerHour") //"mm/h"
            case .temperature : return Translator.sharedInstance.getString(forLanguage: language, string: "celcius") //"°C"
            case .pressure : return Translator.sharedInstance.getString(forLanguage: language, string: "mb") //"mb"
            }
        case "uk2" :
            switch requestedUnits {
            case .distance : return Translator.sharedInstance.getString(forLanguage: language, string: "miles") //"mi"
            case .wind : return Translator.sharedInstance.getString(forLanguage: language, string: "milesPerHour") //"mph"
            case .rainfall : return Translator.sharedInstance.getString(forLanguage: language, string: "milimetersPerHour") //"mm/h"
            case .temperature : return Translator.sharedInstance.getString(forLanguage: language, string: "celcius") //"°C"
            case .pressure : return Translator.sharedInstance.getString(forLanguage: language, string: "pascals") //"hPa"
            }
        default : //case "us" :
            switch requestedUnits {
            case .distance : return Translator.sharedInstance.getString(forLanguage: language, string: "miles") //"mi"
            case .wind : return Translator.sharedInstance.getString(forLanguage: language, string: "milesPerHour") //"mph"
            case .rainfall : return Translator.sharedInstance.getString(forLanguage: language, string: "inchesPerHour") //"in/h"
            case .temperature : return Translator.sharedInstance.getString(forLanguage: language, string: "farenheit") //"°F"
            case .pressure : return Translator.sharedInstance.getString(forLanguage: language, string: "pascals") //"hPa"
            }
        }
    }
}
