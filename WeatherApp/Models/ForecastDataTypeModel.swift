//
//  ForecastDataTypeModel.swift
//  WeatherApp
//
//  Created by Daniel Henshaw on 21/1/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import Foundation


enum ForecastDataType {
    case time, nearestStorm, precipIntensity, precipProbability, temp, feelsLike, dewPoint, humidity, pressure, wind, cloudCover, uvIndex, visibility, ozone, sunriseTime, sunsetTime, moonPhase
}


class ForecastDataTypeModel {
    
    func getForecastDataTypeString(forecastSection: ForecastSection, index: Int) -> String? {
        
        switch forecastSection {
        case .currently : return convertForecastDataTypeToString(type: GlobalVariables.sharedInstance.currentlyData[index])
        case .daily : return convertForecastDataTypeToString(type: GlobalVariables.sharedInstance.dailyData[index])
        case .hourly : return convertForecastDataTypeToString(type: GlobalVariables.sharedInstance.hourlyData[index])
        default : return nil
        }
    }
    
    func convertForecastDataTypeToString(type: ForecastDataType) -> String {
        switch type {
        case .time : return "time"
        case .nearestStorm : return "nearestStorm"
        case .precipIntensity : return "precipIntensity"
        case .precipProbability : return "precipProbability"
        case .temp : return "temp"
        case .feelsLike : return "feelsLike"
        case .dewPoint : return "dewPoint"
        case .humidity : return "humidity"
        case .pressure : return "pressure"
        case .wind : return "wind"
        case .cloudCover : return "cloudCover"
        case .uvIndex : return "uvIndex"
        case .visibility : return "visibility"
        case .ozone : return "ozone"
        case .sunriseTime : return "sunriseTime"
        case .sunsetTime : return "sunsetTime"
        case .moonPhase : return "moonPhase"
        }
    }
    
}
