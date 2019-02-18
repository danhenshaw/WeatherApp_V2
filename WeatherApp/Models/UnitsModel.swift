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

        let units = GlobalVariables.sharedInstance.units
        
        switch units {
        case "si" :
            switch requestedUnits {
            case .distance : return NSLocalizedString("kilometers", comment: "")
            case .wind : return NSLocalizedString("metersPerSecond", comment: "")
            case .rainfall : return NSLocalizedString("milimetersPerHour", comment: "")
            case .temperature : return NSLocalizedString("celcius", comment: "")
            case .pressure : return NSLocalizedString("pascals", comment: "")
            }
        case "ca" :
            switch requestedUnits {
            case .distance : return NSLocalizedString("kilometers", comment: "")
            case .wind : return NSLocalizedString("kilometersPerHour", comment: "")
            case .rainfall : return NSLocalizedString("milimetersPerHour", comment: "")
            case .temperature : return NSLocalizedString("celcius", comment: "")
            case .pressure : return NSLocalizedString("mb", comment: "")
            }
        case "uk2" :
            switch requestedUnits {
            case .distance : return NSLocalizedString("miles", comment: "")
            case .wind : return NSLocalizedString("milesPerHour", comment: "")
            case .rainfall : return NSLocalizedString("milimetersPerHour", comment: "")
            case .temperature : return NSLocalizedString("celcius", comment: "")
            case .pressure : return NSLocalizedString("pascals", comment: "")
            }
        default : //case "us" :
            switch requestedUnits {
            case .distance : return NSLocalizedString("miles", comment: "")
            case .wind : return NSLocalizedString("milesPerHour", comment: "")
            case .rainfall : return NSLocalizedString("inchesPerHour", comment: "")
            case .temperature : return NSLocalizedString("farenheit", comment: "")
            case .pressure : return NSLocalizedString("pascals", comment: "")
            }
        }
    }
}
