//
//  CurrentlyForecastDataMode.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 29/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import Foundation

//enum CurrentlyForecastDataType {
//    case time, nearestStorm, precipIntensity, precipProbability, temp, feelsLike, dewPoint, humidity, pressure, wind, cloudCover, uvIndex, visibility, ozone
//}

struct Currently: Codable {
    
    var time: Int?
    var summary: String?
    var icon: String?
    var nearestStormDistance: Int?
    var nearestStormBearing: Int?
    var precipIntensity: Double?
    var precipProbability: Double?
    var temperature: Double?
    var apparentTemperature: Double?
    var dewPoint: Double?
    var humidity: Double?
    var pressure: Double?
    var windSpeed: Double?
    var windGust: Double?
    var windBearing: Double?
    var cloudCover: Double?
    var uvIndex: Int?
    var visibility: Float?
    var ozone: Double?
    
    
    func getValueString(dataType: ForecastDataType, timeZone: String) -> LabelFormat {
    
        var titleLabelText = "--"
        var valueLabelText = "--"

        switch dataType {
        case .time :
            titleLabelText = "time"
            valueLabelText = FormatDate().date(unixtimeInterval: time ?? 0, timeZone: timeZone, format: .mediumWithTime)
        case .nearestStorm :
            titleLabelText = "storm"
            let direction = getDirection(value: nearestStormBearing ?? 0)
            let distance = "\(nearestStormDistance ?? 0)"
            let units = UnitsModel.sharedInstance.getUnits(requestedUnits: .distance)
            valueLabelText = direction + " " + distance + " " + units
        case .precipIntensity :
            titleLabelText = "precip"
            let value = "\(precipIntensity ?? 0)"
            let units = UnitsModel.sharedInstance.getUnits(requestedUnits: .rainfall)
            valueLabelText = value + " " + units
        case .precipProbability :
            titleLabelText = "precip"
            valueLabelText = "\(Int(round((precipProbability ?? 0.0) * 100)))%"
        case .temp :
            titleLabelText = "temp"
            valueLabelText = "\(Int(round(temperature ?? 0.0)))°"
        case .feelsLike :
            titleLabelText = "feelsLike"
            valueLabelText = "\(Int(round(apparentTemperature ?? 0.0)))°"
        case .dewPoint :
            titleLabelText = "dewPoint"
            valueLabelText = "\(Int(round(dewPoint ?? 0.0)))°"
        case .humidity :
            titleLabelText = "humidity"
            valueLabelText = "\(Int(round((humidity ?? 0.0) * 100)))%"
        case .pressure :
            titleLabelText = "pressure"
            let value = "\(Int(round(pressure ?? 0.0)))"
            let units = UnitsModel.sharedInstance.getUnits(requestedUnits: .pressure)
            valueLabelText = value + " " + units
        case .wind :
            titleLabelText = "wind"
            let direction = getDirection(value: Int(round(windBearing ?? 0.0)))
            let speed = "\(Int(round(windSpeed ?? 0)))"
            let units = UnitsModel.sharedInstance.getUnits(requestedUnits: .wind)
            valueLabelText = direction + " " + speed + " " + units
        case .cloudCover :
            titleLabelText = "clouds"
            valueLabelText = "\(Int(round((cloudCover ?? 0) * 100)))%"
        case .uvIndex :
            titleLabelText = "uvIndex"
            valueLabelText = "\(uvIndex ?? 0)"
        case .visibility :
            titleLabelText = "visibility"
            let value = "\(Int(round(visibility ?? 0.0)))"
            let units = UnitsModel.sharedInstance.getUnits(requestedUnits: .distance)
            valueLabelText = value + " " + units
        case .ozone :
            titleLabelText = "ozone"
            valueLabelText = "\(ozone ?? 0.0)"
        default : break
        }

        return LabelFormat(title: titleLabelText, value: valueLabelText)
    }
    
    
    
    
    func getDirection(value: Int) -> String {
        switch value {
        case 0 ... 22 : return "N"
        case 23 ... 67 : return "NE"
        case 68 ... 112 : return "E"
        case 113 ... 157 : return "SE"
        case 158 ... 202 : return "S"
        case 203 ... 247 : return "SW"
        case 248 ... 292 : return "W"
        case 293 ... 337 : return "NW"
        case 338 ... 360 : return "N"
        default : return ""
        }
    }
}
