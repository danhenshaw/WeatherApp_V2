//
//  RainIntensityModel.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 16/1/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import Foundation

class PrecipIntensityModel {
    
    static let sharedInstance = PrecipIntensityModel()
    
    func getIntensit(intensity: Double, type: String) -> Double {
        
        let precipIntesity = intensity
        var unitsMultiplier = 1.0
        
        if GlobalVariables.sharedInstance.units == "us" { unitsMultiplier = 25.4 }
        
        
        switch type {
        case "snow" :
            
            switch precipIntesity * unitsMultiplier {
                
            // LIGHT SNOW
            case 0              : return 0
            case 0 ... 0.5      : return 0.1
            case 0.25 ... 0.5   : return 0.2
            case 0.5 ... 0.75   : return 0.3
            case 0.75 ... 1     : return 0.4
                
            // MODERATE SNOW
            case 1 ... 1.25      : return 0.5
            case 1.25 ... 1.5    : return 0.54
            case 1.5 ... 1.77    : return 0.58
            case 1.75 ... 2      : return 0.62
            case 2 ... 2.25      : return 0.66
            case 2.25 ... 2.5    : return 0.7
                
            // HEAVY SNOW
            case 2.5 ... 2.75    : return 0.74
            case 2.75 ... 3      : return 0.78
            case 3 ... 3.25      : return 0.82
            case 3.25 ... 3.5    : return 0.86
            case 3.5 ... 3.75    : return 0.9
            case 3.75 ... 4      : return 0.93
            case 4 ... 4.25      : return 0.96
            case 4.25 ... 999999 : return 1

            default             : return 0
                
            }
        
            
        default :
        
            switch precipIntesity * unitsMultiplier {
                
            // LIGHT RAIN
            case 0              : return 0
            case 0 ... 0.2      : return 0.1
            case 0.2 ... 0.5    : return 0.2
            case 0.5 ... 1.5    : return 0.3
            case 1.5 ... 2.5    : return 0.4
                
            // MODERATE RAIN
            case 2.5 ... 4      : return 0.5
            case 4 ... 6        : return 0.6
            case 6 ... 10       : return 0.7
                
            // HEAVY RAIN
            case 10 ... 15      : return 0.75
            case 15 ... 20      : return 0.8
            case 20 ... 35      : return 0.85
            case 135 ... 50     : return 0.9
                
            // VIOLENT RAIN
            case 50 ... 80      : return 0.92
            case 80 ... 120     : return 0.94
            case 120 ... 200    : return 0.96
            case 200 ... 300    : return 0.98
            case 300 ... 360    : return 0.99
            case 360 ... 999999 : return 1
                
            default             : return 0
                
            }
        }
    }
    
}
