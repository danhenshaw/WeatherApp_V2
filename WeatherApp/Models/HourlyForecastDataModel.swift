//
//  HourlyForecastDataModel.swift
//  PageViewTest
//
//  Created by Daniel Henshaw on 29/12/18.
//  Copyright © 2018 Dan Henshaw. All rights reserved.
//

import Foundation

//enum HourlyForecastDataType {
//    case time, precipIntensity, precipProbability, temp, feelsLike, dewPoint, humidity, pressure, wind, cloudCover, uvIndex, visibility, ozone
//}

struct HourlyData: Codable {
    var time: Int?
    var summary: String?
    var icon: String?
    var precipIntensity: Double?
    var precipProbability: Double?
    var precipType: String?
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
}

struct Hourly: Codable {
    var summary: String?
    var icon: String?
    var data: [HourlyData]
    
    func getValueString(dataType: ForecastDataType, index: Int, timeZone: String) -> LabelFormat {
        
        var titleLabelText = "--"
        var valueLabelText = "--"
        
        switch dataType {
        case .time :
            titleLabelText = "time"
            valueLabelText = FormatDate().date(unixtimeInterval: data[index].time ?? 0, timeZone: timeZone, format: .mediumWithTime)
        case .precipIntensity :
            titleLabelText = "\((data[index].precipType) ?? "precip")"
            let value = "\(data[index].precipIntensity ?? 0)"
            let units = UnitsModel.sharedInstance.getUnits(requestedUnits: .rainfall)
            valueLabelText = value + " " + units
        case .precipProbability :
            titleLabelText = "\((data[index].precipType) ?? "precip")"
            valueLabelText = "\(Int(round((data[index].precipProbability ?? 0.0) * 100)))%"
        case .temp :
            titleLabelText = "temp"
            valueLabelText = "\(Int(round(data[index].temperature ?? 0.0)))°"
        case .feelsLike :
            titleLabelText = "feelsLike"
            valueLabelText = "\(Int(round(data[index].apparentTemperature ?? 0.0)))°"
        case .dewPoint :
            titleLabelText = "dewPoint"
            valueLabelText = "\(Int(round(data[index].dewPoint ?? 0.0)))°"
        case .humidity :
            titleLabelText = "humidity"
            valueLabelText = "\(Int(round((data[index].humidity ?? 0.0) * 100)))%"
        case .pressure :
            titleLabelText = "pressure"
            let value = "\(Int(round(data[index].pressure ?? 0.0)))"
            let units = UnitsModel.sharedInstance.getUnits(requestedUnits: .pressure)
            valueLabelText = value + " " + units
        case .wind :
            titleLabelText = "wind"
            let direction = getDirection(value: Int(round(data[index].windBearing ?? 0.0)))
            let speed = "\(Int(round(data[index].windSpeed ?? 0)))"
            let units = UnitsModel.sharedInstance.getUnits(requestedUnits: .wind)
            valueLabelText = direction + " " + speed + " " + units
        case .cloudCover :
            titleLabelText = "clouds"
            valueLabelText = "\(Int(round((data[index].cloudCover ?? 0) * 100)))%"
        case .uvIndex :
            titleLabelText = "uvIndex"
            valueLabelText = "\(data[index].uvIndex ?? 0)"
        case .visibility :
            titleLabelText = "visibility"
            let value = "\(Int(round(data[index].visibility ?? 0.0)))"
            let units = UnitsModel.sharedInstance.getUnits(requestedUnits: .distance)
            valueLabelText = value + " " + units
        case .ozone :
            titleLabelText = "ozone"
            valueLabelText = "\(data[index].ozone ?? 0.0)"
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
